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
    }

    struct Output {
        let searchResults: Observable<[PopUpStore]>
        let filteredStores: Observable<[PopUpStore]>
        let currentLocation: Observable<CLLocation?>
        let errorMessage: Observable<String>
    }

    let input: Input
    var output: Output

    public let selectedFilters = BehaviorRelay<[Filter]>(value: [])

    private let searchQuerySubject = PublishSubject<String>()
    private let locationFilterTappedSubject = PublishSubject<Void>()
    private let categoryFilterTappedSubject = PublishSubject<Void>()
    private let currentLocationRequestedSubject = PublishSubject<Void>()
    private let mapRegionChangedSubject = PublishSubject<GMSCoordinateBounds>()
    private let errorMessageSubject = PublishSubject<String>()

    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let storesService: StoresServiceProtocol

    init(storesService: StoresServiceProtocol = StoresService()) {
        self.storesService = storesService

        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            locationFilterTapped: locationFilterTappedSubject.asObserver(),
            categoryFilterTapped: categoryFilterTappedSubject.asObserver(),
            currentLocationRequested: currentLocationRequestedSubject.asObserver(),
            mapRegionChanged: mapRegionChangedSubject.asObserver()
        )

        self.output = Output(
            searchResults: Observable.just([]),
            filteredStores: Observable.just([]),
            currentLocation: Observable.just(nil),
            errorMessage: errorMessageSubject.asObservable()
        )

        let searchResults = searchQuerySubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[PopUpStore]> in
                guard let self = self, !query.isEmpty else { return .just([]) }
                return storesService.searchStores(query: query)
                    .catch { error in
                        self.errorMessageSubject.onNext("검색 중 오류가 발생했습니다: \(error.localizedDescription)")
                        return .just([])
                    }
            }
            .share(replay: 1)

        let filteredStores = Observable.combineLatest(
            storesService.getAllStores(),
            selectedFilters,
            mapRegionChangedSubject
        )
        .map { [weak self] stores, filters, bounds in
            stores.filter { store in
                self?.isStoreInBounds(store, bounds: bounds) == true &&
                self?.doesStoreMatchFilters(store, filters: filters) == true
            }
        }
        .share(replay: 1)

        let currentLocation = currentLocationRequestedSubject
            .flatMapLatest { [weak self] _ -> Observable<CLLocation?> in
                guard let self = self else { return .just(nil) }
                return self.getCurrentLocation()
            }
            .share(replay: 1)

        Observable.merge(locationFilterTappedSubject, categoryFilterTappedSubject)
            .subscribe(onNext: { [weak self] in
                self?.showFilterOptions()
            })
            .disposed(by: disposeBag)

        self.output = Output(
            searchResults: searchResults,
            filteredStores: filteredStores,
            currentLocation: currentLocation,
            errorMessage: errorMessageSubject.asObservable()
        )
    }

    public func resetFilters() {
        selectedFilters.accept([])
    }

    public func applyFilters() {
        let selectedRegions = selectedFilters.value.filter { $0.type == .location }
        let selectedCategories = selectedFilters.value.filter { $0.type == .category }
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

    private func isStoreInBounds(_ store: PopUpStore, bounds: GMSCoordinateBounds) -> Bool {
        let storeLocation = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        return bounds.contains(storeLocation)
    }

    private func doesStoreMatchFilters(_ store: PopUpStore, filters: [Filter]) -> Bool {
        guard !filters.isEmpty else { return true }
        return filters.allSatisfy { filter in
            switch filter.type {
            case .category:
                return store.categories.contains(filter.name)
            case .location:
                return store.address.contains(filter.name)
            }
        }
    }

    private func showFilterOptions() {
        print("필터 옵션 표시")
    }

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

protocol StoresServiceProtocol {
    func getAllStores() -> Observable<[PopUpStore]>
    func searchStores(query: String) -> Observable<[PopUpStore]>
}
