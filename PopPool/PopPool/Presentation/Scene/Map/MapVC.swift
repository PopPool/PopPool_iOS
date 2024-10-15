import UIKit
import GoogleMaps
import SnapKit
import RxSwift
import RxCocoa

class MapVC: BaseViewController {
    // MARK: - Properties
    private var viewModel: MapVM
    private let disposeBag = DisposeBag()
    private var selectedCategories: [String] = []
    private let userId: String

    private var currentLocationButtonBottomConstraint: Constraint?
    private var listViewButtonBottomConstraint: Constraint?

    private var listViewFullHeight: CGFloat { return view.frame.height - (categoryFilterButton.frame.maxY + 16) }
    private var listViewMiddlePosition: CGFloat {
        return (view.frame.height - listViewFullHeight) / 2  // 리스트뷰 상단이 화면 중간에 위치하도록 계산
    }
    // MARK: - UI Components
    private lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 14.0)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = self
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

    private lazy var locationFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지역선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()

    private lazy var categoryFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카테고리", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()

    private lazy var currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "dot.scope"), for: .normal)
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

    // 리스트뷰 컨테이너 뷰 수정

    private lazy var listContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()


    // 드래그 핸들 뷰 추가
    private lazy var dragHandleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var popupListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PopupListCell.self, forCellWithReuseIdentifier: PopupListCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        return collectionView
    }()

    // 리스트뷰 컨테이너의 bottom 제약조건을 저장하기 위한 변수 추가
    private var listContainerBottomConstraint: Constraint?

    // MARK: - Initialization
    init(viewModel: MapVM, userId: String) {
        print("MapVC에서 전달받은 userId: \(userId)")
        self.viewModel = viewModel
        self.userId = userId
        super.init()
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
        setupGestures()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)
        view.addSubview(listViewButton)
        view.addSubview(popupCardView)
        view.addSubview(listContainerView)
        view.addSubview(locationFilterButton)
        view.addSubview(searchBar)
        view.addSubview(categoryFilterButton)
        listContainerView.addSubview(dragHandleView)
        listContainerView.addSubview(popupListView)

        setupConstraints()
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        locationFilterButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(32)
        }

        categoryFilterButton.snp.makeConstraints { make in
            make.top.equalTo(locationFilterButton)
            make.leading.equalTo(locationFilterButton.snp.trailing).offset(8)
            make.height.equalTo(32)
        }

        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            currentLocationButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16).constraint
            make.width.height.equalTo(40)
        }

        listViewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            listViewButtonBottomConstraint = make.bottom.equalTo(currentLocationButton.snp.top).offset(-16).constraint
            make.width.height.equalTo(40)
        }

        popupCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(100)
        }

        listContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height * 0.8)
            listContainerBottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(view.frame.height).constraint
        }

        dragHandleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(4)
        }

        popupListView.snp.makeConstraints { make in
            make.top.equalTo(categoryFilterButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(listContainerView.snp.bottom).offset(-16)
        }

        popupCardView.isHidden = true
    }

    private func bindViewModel() {
        viewModel.selectedFilters
            .subscribe(onNext: { [weak self] _ in
                self?.updateFilterButtons()
            })
            .disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        // 콜렉션뷰 바인딩 수정
        viewModel.output.filteredStores
            .do(onNext: { stores in
                print("받아온 데이터 수: \(stores.count)")
            })
            .bind(to: popupListView.rx.items(cellIdentifier: PopupListCell.reuseIdentifier, cellType: PopupListCell.self)) { [weak self] (_, store, cell) in
                guard let self = self else { return }

                cell.configure(with: store)
                cell.configureImage(with: nil)  // 기본적으로 nil을 전달하여 기본 이미지 표시

                // 이미지가 있다면 나중에 설정
                self.viewModel.getCustomPopUpStoreImages(for: [store])
                    .subscribe(onNext: { images in
                        if let image = images.first {
                            cell.configureImage(with: image)
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)

        viewModel.output.filteredStores
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] stores in
                self?.updateMapWithStores(stores)
            })
            .disposed(by: disposeBag)

        viewModel.output.storeImages
            .subscribe(onNext: { [weak self] images in
                guard let self = self, let marker = self.mapView.selectedMarker, let store = marker.userData as? MapPopUpStore else { return }
                if let image = images[String(store.id)] {
                    self.popupCardView.configureImage(with: image)
                }
            })
            .disposed(by: disposeBag)

        viewModel.output.searchLocation
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] location in
                guard let self = self, let location = location else { return }
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 14.0)
                self.mapView.animate(to: camera)
            })
            .disposed(by: disposeBag)

        currentLocationButton.rx.tap
            .bind(to: viewModel.input.currentLocationRequested)
            .disposed(by: disposeBag)

        listViewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleListView()
            })
            .disposed(by: disposeBag)

        locationFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleFilterButtonTap(isLocationFilter: true)
            })
            .disposed(by: disposeBag)

        categoryFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleFilterButtonTap(isLocationFilter: false)
            })
            .disposed(by: disposeBag)

        viewModel.output.currentLocation
            .subscribe(onNext: { [weak self] location in
                guard let location = location else { return }
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14.0)
                self?.mapView.animate(to: camera)
            })
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .subscribe(onNext: { [weak self] message in
                self?.showError(message)
            })
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        // 콜렉션뷰 아이템 선택 처리
        popupListView.rx.modelSelected(MapPopUpStore.self)
            .subscribe(onNext: { [weak self] store in
                self?.showStoreDetail(store)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods
    private func updateMapWithStores(_ stores: [MapPopUpStore]) {
        mapView.clear()
        for store in stores {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
            marker.title = store.name
            marker.snippet = store.address
            marker.userData = store
            marker.map = mapView
            print("마커 추가됨: \(marker.position.latitude), \(marker.position.longitude) - \(marker.title ?? "")")
        }
    }

    private func moveCameraToStore(_ store: MapPopUpStore) {
        let position = GMSCameraPosition.camera(withLatitude: store.latitude, longitude: store.longitude, zoom: 14.0)
        mapView.animate(to: position)
    }

    private func updateCellImages(with images: [String: PopUpStoreImage]) {
        for cell in popupListView.visibleCells {
            guard let popupCell = cell as? PopupListCell,
                  let store = popupCell.store,
                  let image = images[String(store.id)] else { continue }

            popupCell.configureImage(with: image)
        }
    }

    private func updatePopupCardView(for store: MapPopUpStore) {
        popupCardView.configure(with: store)

        viewModel.output.storeImages
            .subscribe(onNext: { [weak self] images in
                if let image = images[String(store.id)] {
                    self?.popupCardView.configureImage(with: image)
                }
            })
            .disposed(by: disposeBag)

        popupCardView.isHidden = false

        animatePopupCardAndButtons(to: 100) // 원하는 높이로 설정
    }

    private func animateListContainer(to offset: CGFloat) {
        listContainerBottomConstraint?.update(offset: offset)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func animatePopupCardAndButtons(to offset: CGFloat) {
        let newButtonOffset = offset > 0 ? -offset - 40 : -30
        currentLocationButtonBottomConstraint?.update(offset: newButtonOffset)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hidePopupCardView() {
        popupCardView.isHidden = true
        animatePopupCardAndButtons(to: 0)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showFilterBottomSheet(isCategoryFilter: Bool) {
        let filterVC = FilterBottomSheetViewController(viewModel: viewModel)
        filterVC.isCategoryFilter = isCategoryFilter
        filterVC.modalPresentationStyle = .overFullScreen
        filterVC.modalTransitionStyle = .coverVertical

        filterVC.onFiltersApplied = { [weak self] in
            self?.viewModel.applyFilters()
            self?.updateFilterButtons()
        }

        present(filterVC, animated: true, completion: nil)
    }

    private func updateFilterButtons() {
        let locationText = viewModel.getSelectedLocationText()
        updateFilterButton(locationFilterButton, withText: locationText, isLocationFilter: true)

        let categoryText = viewModel.getSelectedCategoryText()
        updateFilterButton(categoryFilterButton, withText: categoryText, isLocationFilter: false)
    }

    private func updateFilterButton(_ button: UIButton, withText text: String, isLocationFilter: Bool) {
        button.setTitle(text, for: .normal)

        if (isLocationFilter && text != "지역선택") || (!isLocationFilter && text != "카테고리") {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.borderWidth = 0

            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let xmarkImage = UIImage(systemName: "xmark", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
            button.setImage(xmarkImage, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
            button.semanticContentAttribute = .forceRightToLeft
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.systemBlue, for: .normal)
            button.layer.borderWidth = 1
            button.setImage(nil, for: .normal)
        }

        button.sizeToFit()
        button.invalidateIntrinsicContentSize()
    }

    // 팬 제스처 핸들러 수정
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let currentTopOffset = listContainerView.frame.origin.y  // 리스트뷰 상단 위치
        let searchBarBottom = searchBar.frame.maxY  // 서치바 하단 위치
        let categoryButtonBottom = categoryFilterButton.frame.maxY  // 카테고리 버튼 하단 위치

        switch gesture.state {
        case .changed:
            // 리스트뷰의 상단 위치를 변경
            let newTopOffset = max(searchBarBottom, currentTopOffset + translation.y)
            listContainerView.frame.origin.y = newTopOffset
            view.layoutIfNeeded()

            updateMapVisibility()

            gesture.setTranslation(.zero, in: view)

        case .ended:
            var targetOffset: CGFloat

            // 리스트뷰가 카테고리 버튼에 닿을 때
            if currentTopOffset <= categoryButtonBottom {
                targetOffset = categoryButtonBottom  // 리스트뷰 상단을 카테고리 버튼에 맞춤
            }
            // 중간 위치에 있을 때
            else if currentTopOffset < listViewMiddlePosition {
                targetOffset = listViewMiddlePosition  // 리스트뷰를 화면 중간으로 이동
            }
            // 리스트뷰가 완전히 내려갈 때
            else {
                targetOffset = view.frame.height  // 리스트뷰를 화면 아래로 내림
            }

            // 애니메이션으로 리스트뷰 이동
            UIView.animate(withDuration: 0.3) {
                self.listContainerView.frame.origin.y = targetOffset
                self.view.layoutIfNeeded()
            }

        default:
            break
        }
    }


    // 맵뷰 가시성 업데이트 함수
    private func updateMapVisibility() {
        let listViewTop = listContainerView.frame.origin.y  // 리스트뷰 상단 위치
        let categoryButtonBottom = categoryFilterButton.frame.maxY  // 카테고리 버튼 하단 위치

        // 리스트뷰 상단이 카테고리 버튼 하단에 닿으면 맵뷰를 숨김
        if listViewTop <= categoryButtonBottom {
            animateMapView(hidden: true)
        } else {
            animateMapView(hidden: false)
        }
    }




    private func animateMapView(hidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.mapView.alpha = hidden ? 0 : 1
        }
    }

    private func toggleListView() {
        let currentOffset = listContainerBottomConstraint?.layoutConstraints.first?.constant ?? 0
        let targetOffset = (currentOffset == 0) ? listViewMiddlePosition : 0

        animateListContainer(to: targetOffset)
    }

    // MARK: - 탭 제스처 설정
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func handleFilterButtonTap(isLocationFilter: Bool) {
        let buttonTitle = isLocationFilter ? locationFilterButton.titleLabel?.text : categoryFilterButton.titleLabel?.text
        if buttonTitle != "지역선택" && buttonTitle != "카테고리" {
            if isLocationFilter {
                viewModel.removeAllLocationFilters()
            } else {
                viewModel.removeAllCategoryFilters()
            }
            updateFilterButtons()
        } else {
            showFilterBottomSheet(isCategoryFilter: !isLocationFilter)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showStoreDetail(_ store: MapPopUpStore) {
        print("Selected store: \(store.name)")
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        listContainerView.addGestureRecognizer(panGesture)
    }
}

// MARK: - GMSMapViewDelegate
extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("마커 탭: \(marker.title ?? "")")

        guard let popupStore = marker.userData as? MapPopUpStore else {
            return false
        }

        updatePopupCardView(for: popupStore)
        let cameraUpdate = GMSCameraUpdate.setTarget(marker.position, zoom: 14.0)
        mapView.animate(with: cameraUpdate)

        return true
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let bounds = mapView.projection.visibleRegion()
        let coordinateBounds = GMSCoordinateBounds(region: bounds)

        let roundedNELat = Double(String(format: "%.4f", coordinateBounds.northEast.latitude))!
        let roundedNELon = Double(String(format: "%.4f", coordinateBounds.northEast.longitude))!
        let roundedSWLat = Double(String(format: "%.4f", coordinateBounds.southWest.latitude))!
        let roundedSWLon = Double(String(format: "%.4f", coordinateBounds.southWest.longitude))!

        print("MapVC - 맵뷰 포지션")
        print("Bounds: NE Lat: \(roundedNELat), NE Lon: \(roundedNELon), SW Lat: \(roundedSWLat), SW Lon: \(roundedSWLon)")
        print("선택된 카테고리: \(selectedCategories)")

        let categories = viewModel.getSelectedCategory()
        viewModel.input.categoryFilterChanged.onNext(categories)
        viewModel.input.mapRegionChanged.onNext(GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D(latitude: roundedSWLat, longitude: roundedSWLon),
            coordinate: CLLocationCoordinate2D(latitude: roundedNELat, longitude: roundedNELon)
        ))
    }
}

// MARK: - UIScrollViewDelegate
extension MapVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == popupListView {
            // 스크롤이 가능하도록 설정 (조건 제거)
            scrollView.isScrollEnabled = true
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MapVC: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 16

        let totalSpacing = (2 * collectionView.contentInset.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)

        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
