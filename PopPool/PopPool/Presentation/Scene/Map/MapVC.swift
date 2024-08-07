//
//  MapVC.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import UIKit
import GoogleMaps
import SnapKit
import RxSwift
import RxCocoa

class MapVC: BaseViewController {

    // MARK: - Properties
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()

    // MARK: - UI Components
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        return mapView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "위치 검색"
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        return searchBar
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("필터", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .blue
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - Initialization
    init(viewModel: MapVM) {
        self.viewModel = viewModel
        super.init(/*nibName: nil, bundle: nil*/)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        view.addSubview(currentLocationButton)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(filterButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }

        filterButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.width.height.equalTo(40)
        }
    }

    private func bindViewModel() {
        // 검색 기능
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<CLLocationCoordinate2D?> in
                guard let self = self, !query.isEmpty else { return .just(nil) }
                return self.viewModel.searchLocation(query: query)
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] coordinate in
                self?.moveCamera(to: coordinate)
            })
            .disposed(by: disposeBag)

        // 현재 위치 버튼
        currentLocationButton.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<CLLocationCoordinate2D?> in
                guard let self = self else { return .just(nil) }
                return self.viewModel.getCurrentLocation()
            }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] coordinate in
                self?.moveCamera(to: coordinate)
            })
            .disposed(by: disposeBag)

        // 필터 버튼 (아직 기능 구현 X)
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterOptions()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func moveCamera(to coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: 15.0)
        mapView.animate(to: camera)
    }

    private func showFilterOptions() {
        // 필터 옵션을 보여주는 로직 (아직 미구현)
        print("Filter options tapped")
    }
}
