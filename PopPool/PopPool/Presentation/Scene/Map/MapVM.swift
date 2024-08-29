import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import GoogleMaps

class MapVM {
    struct Input {
        let searchQuery: AnyObserver<String> // 검색어 입력 옵저버
        let locationFilterTapped: AnyObserver<Void> // 위치 필터 버튼 탭 이벤트
        let categoryFilterTapped: AnyObserver<Void> // 카테고리 필터 버튼 탭 이벤트
        let currentLocationRequested: AnyObserver<Void> // 현재 위치 요청 이벤트
        let mapRegionChanged: AnyObserver<GMSCoordinateBounds> // 지도 영역 변경 이벤트
        let categoryFilterChanged: AnyObserver<[String]> // String?에서 [String]으로 변경
    }

    struct Output {
        let searchResults: Observable<[PopUpStore]> // 검색 결과 옵저버블
        let filteredStores: Observable<[PopUpStore]> // 필터링된 스토어 목록 옵저버블
        let currentLocation: Observable<CLLocation?> // 현재 위치 옵저버블
        let errorMessage: Observable<String> // 에러 메시지 옵저버블
    }

    // 프로퍼티
    // 추후 백엔드와 협의를 통해 null값일때 모든카테고리 를 적용할수있도록 요구예정
    private let allCategories = ["GAME", "LIFESTYLE", "PETS", "BEAUTY", "SPORTS", "ANIMATION", "ENTERTAINMENT", "TRAVEL", "ART", "FOOD_COOKING", "KIDS", "FASHION"]

    let input: Input
    lazy var output: Output = {
        let searchResults = searchQuerySubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[PopUpStore]> in
                guard let self = self, !query.isEmpty else { return .just([]) }
                return self.storeService.searchStores(query: query)
                    .catch { error in
                        print("검색 실패: \(error)")
                        self.errorMessageSubject.onNext("검색 중 오류가 발생했습니다: \(error.localizedDescription)")
                        return .just([])
                    }
            }
            .share(replay: 1)

        let filteredStores = mapRegionChangedSubject
            .withLatestFrom(categoryFilterChangedSubject.startWith([])) { (bounds, categories) in
                return (bounds, categories)
            }
            .flatMapLatest { [weak self] (bounds, categories) -> Observable<[PopUpStore]> in
                guard let self = self else { return .just([]) }
                print("쿼리 파라미터: Bounds - NE Lat: \(bounds.northEast.latitude), NE Lon: \(bounds.northEast.longitude), SW Lat: \(bounds.southWest.latitude), SW Lon: \(bounds.southWest.longitude)")
                print("카테고리: \(categories.isEmpty ? "모든 카테고리" : categories.joined(separator: ","))")
                return self.storeService.getPopUpStoresInBounds(
                    northEastLat: bounds.northEast.latitude,
                    northEastLon: bounds.northEast.longitude,
                    southWestLat: bounds.southWest.latitude,
                    southWestLon: bounds.southWest.longitude,
                    categories: categories.isEmpty ? self.allCategories : categories
                )
                .catch { error in
                    print("스토어 정보 가져오기 실패: \(error)")
                    self.errorMessageSubject.onNext("스토어 정보를 가져오는데 실패했습니다.")
                    return .just([])
                }
            }
            .share(replay: 1)

        let currentLocation = currentLocationRequestedSubject
            .flatMapLatest { [weak self] _ -> Observable<CLLocation?> in
                guard let self = self else { return .just(nil) }
                return self.getCurrentLocation()
            }
            .share(replay: 1)

        return Output(
            searchResults: searchResults,
            filteredStores: filteredStores,
            currentLocation: currentLocation,
            errorMessage: errorMessageSubject.asObservable()
        )
    }()

    // 내부 Subjects 정의
    private let searchQuerySubject = PublishSubject<String>()
    private let locationFilterTappedSubject = PublishSubject<Void>()
    private let categoryFilterTappedSubject = PublishSubject<Void>()
    private let currentLocationRequestedSubject = PublishSubject<Void>()
    private let mapRegionChangedSubject = PublishSubject<GMSCoordinateBounds>()
    private let errorMessageSubject = PublishSubject<String>()
    private let locationManager = CLLocationManager()

    private let disposeBag = DisposeBag()
    private let storeService: StoresServiceProtocol

    public let selectedFilters = BehaviorRelay<[Filter]>(value: [])
    private let categoryFilterChangedSubject = PublishSubject<[String]>() // String?에서 [String]으로 변경


    init(storeService: StoresServiceProtocol) {
        self.storeService = storeService

        // Input 초기화
        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            locationFilterTapped: locationFilterTappedSubject.asObserver(),
            categoryFilterTapped: categoryFilterTappedSubject.asObserver(),
            currentLocationRequested: currentLocationRequestedSubject.asObserver(),
            mapRegionChanged: mapRegionChangedSubject.asObserver(),
            categoryFilterChanged: categoryFilterChangedSubject.asObserver()
        )

        // 바인딩 설정
        setupBindings()
    }

    // 필터 및 기타 바인딩 설정
    private func setupBindings() {
        Observable.merge(locationFilterTappedSubject, categoryFilterTappedSubject)
            .subscribe(onNext: { [weak self] in
                self?.showFilterOptions()
            })
            .disposed(by: disposeBag)
    }

    // 필터 관리 메서드
    public func resetFilters() {
        selectedFilters.accept([])
        categoryFilterChangedSubject.onNext([]) // 빈 배열을 전송
    }

    public func applyFilters() {
        let selectedCategories = selectedFilters.value
            .filter { $0.type == .category }
            .map { $0.name }
        categoryFilterChangedSubject.onNext(selectedCategories)
    }
    public func addFilter(_ filter: Filter) {
        var currentFilters = selectedFilters.value
        if !currentFilters.contains(where: { $0.id == filter.id }) {
            currentFilters.append(filter)
            selectedFilters.accept(currentFilters)
        }
    }

    public func removeFilter(_ filter: Filter) {
        var currentFilters = selectedFilters.value
        currentFilters.removeAll(where: { $0.id == filter.id })
        selectedFilters.accept(currentFilters)
    }

    // MapVM 클래스 내에서 카테고리 필터를 반환하는 메서드
    public func getSelectedCategory() -> String? {
        // selectedFilters에서 type이 .category인 첫 번째 필터를 찾아서 반환합니다.
        return selectedFilters.value.first(where: { $0.type == .category })?.name
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
    private func isStoreInBounds(_ store: PopUpStore, bounds: GMSCoordinateBounds) -> Bool {
        let storeLocation = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        return bounds.contains(storeLocation)
    }

    // 필터 적용 여부 확인
    private func doesStoreMatchFilters(_ store: PopUpStore, filters: [Filter]) -> Bool {
        guard !filters.isEmpty else { return true }
        return filters.allSatisfy { filter in
            switch filter.type {
            case .category:
                return store.category.contains(filter.name)
            case .location:
                return store.address.contains(filter.name)
            }
        }
        func convertCategoriesToEnglish(_ categories: [String]) -> [String] {
            return categories.map { CategoryUtility.shared.toEnglishCategory($0) }
        }

        // 필터링된 스토어를 가져올 때
        func getFilteredStores(bounds: GMSCoordinateBounds, categories: [String]) -> Observable<[PopUpStore]> {
            let englishCategories = convertCategoriesToEnglish(categories)
            return storeService.getPopUpStoresInBounds(
                northEastLat: bounds.northEast.latitude,
                northEastLon: bounds.northEast.longitude,
                southWestLat: bounds.southWest.latitude,
                southWestLon: bounds.southWest.longitude,
                categories: englishCategories
            )
        }
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
