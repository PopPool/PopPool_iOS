import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import GoogleMaps

class MapVM {
    struct Input {
        let searchQuery: AnyObserver<String>
        let locationFilterTapped: AnyObserver<Void>
        let categoryFilterTapped: AnyObserver<Void>
        let currentLocationRequested: AnyObserver<Void>
        let mapRegionChanged: AnyObserver<GMSCoordinateBounds>
        let categoryFilterChanged: AnyObserver<[String]>
        let locationFilterChanged: AnyObserver<[String]>
    }

    struct Output {
        let searchResults: Observable<[MapPopUpStore]>
        let filteredStores: Observable<[MapPopUpStore]>
        let currentLocation: Observable<CLLocation?>
        let errorMessage: Observable<String>
        let searchLocation: Observable<CLLocationCoordinate2D?>
        let storeImages: Observable<[String: PopUpStoreImage]>

    }

    private let allCategories = ["GAME", "LIFESTYLE", "PETS", "BEAUTY", "SPORTS", "ANIMATION", "ENTERTAINMENT", "TRAVEL", "ART", "FOOD_COOKING", "KIDS", "FASHION"]
    private let userId: String

    let input: Input

    lazy var output: Output = {
        let searchAndFilteredStores = Observable.combineLatest(
            self.searchQuerySubject.startWith(""),
            self.mapRegionChangedSubject,
            self.categoryFilterChangedSubject.startWith([])
        )
        .flatMapLatest { [weak self] (query, bounds, categories) -> Observable<[MapPopUpStore]> in
            guard let self = self else { return .just([]) }

            if !query.isEmpty {
                return self.storeService.search_popUpStores(query: query)
            } else {
                return self.storeService.getPopUpStoresInBounds(
                    northEastLat: bounds.northEast.latitude,
                    northEastLon: bounds.northEast.longitude,
                    southWestLat: bounds.southWest.latitude,
                    southWestLon: bounds.southWest.longitude,
                    categories: categories.isEmpty ? self.allCategories : categories
                )
            }
        }
        .catch { error in
            print("데이터 가져오기 실패: \(error)")
            self.errorMessageSubject.onNext("데이터를 가져오는데 실패했습니다.")
            return .just([])
        }
        .share(replay: 1)

        let currentLocation = self.currentLocationRequestedSubject
            .flatMapLatest { [weak self] _ -> Observable<CLLocation?> in
                guard let self = self else { return .just(nil) }
                return self.getCurrentLocation()
            }
            .share(replay: 1)

        let searchLocation = self.searchQuerySubject
                    .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                    .flatMapLatest { [weak self] query -> Observable<CLLocationCoordinate2D?> in
                        guard let self = self, !query.isEmpty else { return .just(nil) }
                        return self.geocodeAddress(query)
                    }
                    .share(replay: 1)
        let storeImages = searchAndFilteredStores
            .flatMapLatest { [weak self] (stores: [MapPopUpStore]) -> Observable<[String: PopUpStoreImage]> in
                guard let self = self else { return .just([:]) }
                let page = 1
                let size = stores.count
                return self.storeService.getCustomPopUpStoreImages(userId: self.userId, page: page, size: size)
                    .map { images in
                        Dictionary(uniqueKeysWithValues: images.map { (String($0.id), $0) }) 
                    }
            }
            .share(replay: 1)



        return Output(
            searchResults: searchAndFilteredStores,
            filteredStores: searchAndFilteredStores,
            currentLocation: currentLocation,
            errorMessage: self.errorMessageSubject.asObservable(),
            searchLocation: searchLocation,
            storeImages: storeImages




        )
    }()

    // 내부 Subjects 정의
    private let searchQuerySubject = PublishSubject<String>()
    private let locationFilterTappedSubject = PublishSubject<Void>()
    private let categoryFilterTappedSubject = PublishSubject<Void>()
    private let currentLocationRequestedSubject = PublishSubject<Void>()
    private let locationFilterChangedSubject = PublishSubject<[String]>()
    private let mapRegionChangedSubject = PublishSubject<GMSCoordinateBounds>()
    private let errorMessageSubject = PublishSubject<String>()
    private let locationManager = CLLocationManager()

    private let disposeBag = DisposeBag()
    private let storeService: StoresServiceProtocol

    public let selectedFilters = BehaviorRelay<[Filter]>(value: [])
    private let categoryFilterChangedSubject = PublishSubject<[String]>()

    init(storeService: StoresServiceProtocol, userId: String) {
        print("MapVM 초기화, userId: \(userId)")
        self.storeService = storeService
        self.userId = userId.isEmpty ? Constants.userId : userId


        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            locationFilterTapped: locationFilterTappedSubject.asObserver(),
            categoryFilterTapped: categoryFilterTappedSubject.asObserver(),
            currentLocationRequested: currentLocationRequestedSubject.asObserver(),
            mapRegionChanged: mapRegionChangedSubject.asObserver(),
            categoryFilterChanged: categoryFilterChangedSubject.asObserver(),
            locationFilterChanged: locationFilterChangedSubject.asObserver()
        )

        setupBindings()
    }

    func getCustomPopUpStoreImages(for stores: [MapPopUpStore]) -> Observable<[PopUpStoreImage]> {


        // userId와 page, size를 이용해 맞춤형 팝업 스토어 이미지를 가져옵니다.
        return storeService.getCustomPopUpStoreImages(userId: userId, page: 1, size: max(1, stores.count))
    }

    // 필터 및 기타 바인딩 설정
    private func setupBindings() {
        Observable.merge(locationFilterTappedSubject, categoryFilterTappedSubject)
            .subscribe(onNext: { [weak self] in
                self?.showFilterOptions()
            })
            .disposed(by: disposeBag)
    }

    private func geocodeAddress(_ address: String) -> Observable<CLLocationCoordinate2D?> {
        return Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    observer.onNext(nil)
                    observer.onCompleted()
                } else if let location = placemarks?.first?.location?.coordinate {
                    observer.onNext(location)
                    observer.onCompleted()
                } else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getSelectedLocationText() -> String {
        let locations = selectedFilters.value.filter { $0.type == .location }.sorted { $0.name < $1.name }
        if locations.isEmpty {
            return "지역선택"
        } else if locations.count == 1 {
            return locations[0].name
        } else {
            return "\(locations[0].name) 외 \(locations.count - 1)개"
        }
    }

    public func getSelectedCategoryText() -> String {
        let categories = selectedFilters.value.filter { $0.type == .category }.sorted { $0.name < $1.name }
        if categories.isEmpty {
            return "카테고리"
        } else if categories.count == 1 {
            return categories[0].name
        } else {
            return "\(categories[0].name) 외 \(categories.count - 1)개"
        }
    }
    public func addCategoryFilter(_ category: String) {
        let filter = Filter(id: UUID().uuidString, name: category, type: .category)
        addFilter(filter)
    }

    public func removeCategoryFilter(_ category: String) {
        let filter = Filter(id: "", name: category, type: .category)
        removeFilter(filter)
    }

    // 필터 관리 메서드
    public func resetFilters() {
        selectedFilters.accept([])
        categoryFilterChangedSubject.onNext([])
    }

    public func applyFilters() {
        let selectedCategories = selectedFilters.value
            .filter { $0.type == .category }
            .map { $0.name }
        categoryFilterChangedSubject.onNext(selectedCategories)

        let selectedLocations = selectedFilters.value
              .filter { $0.type == .location }
              .map { $0.name }
          locationFilterChangedSubject.onNext(selectedLocations)
    }

    public func addFilter(_ filter: Filter) {
        var currentFilters = selectedFilters.value
        if !currentFilters.contains(where: { $0.name == filter.name && $0.type == filter.type }) {
            currentFilters.append(filter)
            selectedFilters.accept(currentFilters)
        }
    }

    public func removeFilter(_ filter: Filter) {
        var currentFilters = selectedFilters.value
        currentFilters.removeAll(where: { $0.name == filter.name && $0.type == filter.type })
        selectedFilters.accept(currentFilters)
    }

    public func getSelectedCategory() -> [String] {
        let selectedCategories = selectedFilters.value
            .filter { $0.type == .category }
            .map { $0.name }
        return selectedCategories.isEmpty ? allCategories : selectedCategories
    }
    public func removeAllLocationFilters() {
            let updatedFilters = selectedFilters.value.filter { $0.type != .location }
            selectedFilters.accept(updatedFilters)
            applyFilters()
        }

        public func removeAllCategoryFilters() {
            let updatedFilters = selectedFilters.value.filter { $0.type != .category }
            selectedFilters.accept(updatedFilters)
            applyFilters()
        }
    

    // 헬퍼 메서드 - 현재 위치 얻기
    private func getCurrentLocation() -> Observable<CLLocation?> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }

            switch self.locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
                if let location = self.locationManager.location {
                    observer.onNext(location)
                    observer.onCompleted()
                } else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
                observer.onNext(nil)
                observer.onCompleted()
            case .restricted, .denied:
                self.errorMessageSubject.onNext("위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.")
                observer.onNext(nil)
                observer.onCompleted()
            @unknown default:
                observer.onNext(nil)
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }

    // 스토어가 지도 영역 내에 있는지 확인
    private func isStoreInBounds(_ store: MapPopUpStore, bounds: GMSCoordinateBounds) -> Bool {
        let storeLocation = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        return bounds.contains(storeLocation)
    }

    // 필터 적용 여부 확인
    private func doesStoreMatchFilters(_ store: MapPopUpStore, filters: [Filter]) -> Bool {
        guard !filters.isEmpty else { return true }
        return filters.allSatisfy { filter in
            switch filter.type {
            case .category:
                return store.category.contains(filter.name)
            case .location:
                return store.address.contains(filter.name)
            }
        }
        
    }

    func convertCategoriesToEnglish(_ categories: [String]) -> [String] {
        return categories.map { CategoryUtility.shared.toEnglishCategory($0) }
    }

    // 필터링된 스토어를 가져올 때
    func getFilteredStores(bounds: GMSCoordinateBounds, categories: [String]) -> Observable<[MapPopUpStore]> {
        let englishCategories = convertCategoriesToEnglish(categories)
        return storeService.getPopUpStoresInBounds(
            northEastLat: bounds.northEast.latitude,
            northEastLon: bounds.northEast.longitude,
            southWestLat: bounds.southWest.latitude,
            southWestLon: bounds.southWest.longitude,
            categories: englishCategories
        )
    }

    // 필터 옵션 표시 메서드
    private func showFilterOptions() {
        print("필터 옵션 표시")
    }

    // 필터 구조체 및 타입 정의
    public struct Filter {
        let id: String
        let name: String
        let type: FilterType
    }

    public enum FilterType {
        case category
        case location
    }
}
