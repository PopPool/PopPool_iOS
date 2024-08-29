import UIKit
import GoogleMaps
import SnapKit
import RxSwift
import RxCocoa

class MapVC: BaseViewController {
    // MARK: - Properties
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()
    private var selectedCategory: String?


    // MARK: - UI Components
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 14.0)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = self  // 지도 이벤트를 감지하기 위해 delegate 설정
        return mapView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "팝업스토어명, 지역을 입력해보세요"
        searchBar.backgroundImage = UIImage()  
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.borderStyle = .none
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
        }
        return searchBar
    }()

    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationFilterButton, categoryFilterButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var locationFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("서울 / 송파구 외 2개", for: .normal)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var categoryFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("요리 / 음식 외 2개", for: .normal)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    private lazy var listViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    private lazy var popupCardView: PopupCardView = {
        let view = PopupCardView()
        return view
    }()

    private lazy var popupListView: UITableView = {
        let tableView = UITableView()
        tableView.register(PopupListCell.self, forCellReuseIdentifier: PopupListCell.identifier)
        return tableView
    }()

    private var resizeIndicator: UIView!

    // MARK: - Initialization
    init(viewModel: MapVM) {
        self.viewModel = viewModel
        super.init()
        // 기본값을 설정하여 초기 진입 시 모든 카테고리를 포함하도록 설정
//        selectedCategory = "all" // "all" 또는 ""로 설정하여 모든 카테고리 필터링
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupTapGesture()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(popupListView)
        view.addSubview(searchBar)
        view.addSubview(filterStackView)
        view.addSubview(currentLocationButton)
        view.addSubview(listViewButton)
        view.addSubview(popupCardView)

        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(popupCardView.snp.top).offset(-16)
            make.width.height.equalTo(40)
        }

        listViewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(popupCardView.snp.top).offset(-16)
            make.width.height.equalTo(40)
        }

        popupCardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        popupListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(view.frame.height)
            make.height.equalTo(view.frame.height / 2)
        }

        resizeIndicator = UIView()
        resizeIndicator.backgroundColor = .lightGray
        resizeIndicator.layer.cornerRadius = 2
        popupListView.addSubview(resizeIndicator)

        resizeIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
    }

    private func bindViewModel() {
        // 검색어 입력에 따른 검색 처리
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        // 필터링된 스토어 목록을 받아 지도에 표시
        viewModel.output.filteredStores
            .subscribe(onNext: { [weak self] stores in
                self?.updateMapWithStores(stores)
            })
            .disposed(by: disposeBag)

        // 현재 위치 요청에 따른 지도 이동
        currentLocationButton.rx.tap
            .bind(to: viewModel.input.currentLocationRequested)
            .disposed(by: disposeBag)

        // 리스트 보기 버튼 탭 처리
        listViewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showListView()
            })
            .disposed(by: disposeBag)

        // 위치 필터 버튼 탭 처리
        locationFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterBottomSheet()
            })
            .disposed(by: disposeBag)

        // 카테고리 필터 버튼 탭 처리
        categoryFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterBottomSheet()
            })
            .disposed(by: disposeBag)

        // 필터링된 스토어 목록을 리스트에 표시
        viewModel.output.filteredStores
            .bind(to: popupListView.rx.items(cellIdentifier: PopupListCell.identifier, cellType: PopupListCell.self)) { index, store, cell in
                cell.configure(with: store)
            }
            .disposed(by: disposeBag)

        // 현재 위치 업데이트
        viewModel.output.currentLocation
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14.0)
                self?.mapView.animate(to: camera)
            })
            .disposed(by: disposeBag)

        // 에러 메시지 처리
        viewModel.output.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.showError(message)
            })
            .disposed(by: disposeBag)

        // 검색 버튼 클릭 시 키보드 내리기
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func updateMapWithStores(_ stores: [PopUpStore]) {
        mapView.clear()
        for store in stores {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
            marker.title = store.name
            marker.snippet = store.address
            marker.map = mapView
        }
    }

    private func showListView() {
        if popupListView.frame.origin.y >= view.frame.height {
            popupListView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(view.frame.height / 2)
            }
            view.layoutIfNeeded()

            popupListView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.popupListView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                self.popupListView.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.popupListView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            }
        }

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        popupListView.addGestureRecognizer(panGesture)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showFilterBottomSheet() {
        let filterVC = FilterBottomSheetViewController(viewModel: viewModel)
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.modalTransitionStyle = .coverVertical

        // 필터가 저장될 때 호출되는 클로저
        filterVC.onCategoryFilterApplied = { [weak self] selectedCategory in
            self?.selectedCategory = selectedCategory
            let categories = selectedCategory.map { [$0] } ?? []
            self?.viewModel.input.categoryFilterChanged.onNext(selectedCategory != nil ? [selectedCategory!] : [])
        }

        present(filterVC, animated: true, completion: nil)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let topPosition = view.safeAreaInsets.top
        let bottomPosition = view.frame.height

        switch gesture.state {
        case .changed:
            let newY = max(topPosition, min(popupListView.frame.origin.y + translation.y, bottomPosition))
            popupListView.frame.origin.y = newY
            gesture.setTranslation(.zero, in: view)

        case .ended:
            let velocity = gesture.velocity(in: view)

            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = bottomPosition
                    self.searchBar.isHidden = false
                    self.filterStackView.isHidden = false
                    self.resizeIndicator.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = topPosition
                    self.popupListView.snp.remakeConstraints { make in
                        make.top.equalToSuperview()
                        make.leading.trailing.bottom.equalToSuperview()
                    }
                    self.view.layoutIfNeeded()
                    self.resizeIndicator.isHidden = true
                }
            }

        default:
            break
        }
    }

    // MARK: - 탭 제스처 설정
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - GMSMapViewDelegate 구현
extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let bounds = mapView.projection.visibleRegion()
        let coordinateBounds = GMSCoordinateBounds(region: bounds)

        print("MapVC - mapView idleAt position:")
        print("Bounds: \(coordinateBounds)")
        print("Selected Category: \(String(describing: selectedCategory))")

        let categories = viewModel.getSelectedCategory().map { [$0] } ?? []
        viewModel.input.categoryFilterChanged.onNext(categories)
        viewModel.input.mapRegionChanged.onNext(coordinateBounds)
    }
}
