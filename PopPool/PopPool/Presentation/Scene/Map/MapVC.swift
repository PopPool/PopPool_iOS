import UIKit
import GoogleMaps
import SnapKit
import RxSwift
import RxCocoa

class MapVC: BaseViewController {
    // MARK: - Properties
    private let viewModel: MapVM
    private let disposeBag = DisposeBag()
    private var selectedCategories: [String] = []
    
    
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
    
    private lazy var popupListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        let width = (UIScreen.main.bounds.width - 48) / 2 // 2열로 설정, 좌우 여백 16씩, 중간 여백 16
        layout.itemSize = CGSize(width: width, height: 300)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PopupListCell.self, forCellWithReuseIdentifier: PopupListCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 10, bottom: 10, right: 10)
        return collectionView
    }()
    private var resizeIndicator: UIView!
    
    // MARK: - Initialization
    init(viewModel: MapVM, userId: String) {
        let storeService = AppDIContainer.shared.resolve(type: StoresServiceProtocol.self)
        self.viewModel = viewModel
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
         setupListViewPanGesture()

    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(popupListView)
        view.addSubview(searchBar)
        view.addSubview(currentLocationButton)
        view.addSubview(listViewButton)
        view.addSubview(popupCardView)
        view.addSubview(locationFilterButton)
        view.addSubview(categoryFilterButton)
        
        
        
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-30)
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
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(popupCardView.snp.top).offset(-16)
            make.width.height.equalTo(40)
        }
        
        listViewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(currentLocationButton.snp.top).offset(-16)
            make.width.height.equalTo(40)
        }
        
        popupCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(100)
        }
        popupCardView.isHidden = true
        
        
        popupListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(view.frame.height)
//            make.height.equalTo(view.frame.height / 2)
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
    
    private func setupListViewPanGesture() {
           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
           popupListView.addGestureRecognizer(panGesture)
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
        
        viewModel.output.filteredStores
            .bind(to: popupListView.rx.items(cellIdentifier: PopupListCell.reuseIdentifier, cellType: PopupListCell.self)) { index, store, cell in
                cell.configure(with: store)
                cell.tag = Int(store.id)

            }
            .disposed(by: disposeBag)
        viewModel.output.filteredStores
               .flatMapLatest { [weak self] stores -> Observable<([PopUpStore], [PopUpStoreImage])> in
                   guard let self = self else { return .just(([], [])) }
                   return Observable.zip(
                       Observable.just(stores),
                       self.viewModel.getCustomPopUpStoreImages(for: stores)
                   )
               }
               .subscribe(onNext: { [weak self] stores, images in
                   self?.updateMapWithStores(stores)
                   self?.updateCellImages(with: Dictionary(uniqueKeysWithValues: images.map { (String($0.id), $0) }))
               })
               .disposed(by: disposeBag)


        viewModel.output.filteredStores
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] stores in
                self?.updateMapWithStores(stores)
            })
            .disposed(by: disposeBag)
        
        

        viewModel.output.storeImages
            .subscribe(onNext: { [weak self] images in
                guard let self = self, let marker = self.mapView.selectedMarker, let store = marker.userData as? PopUpStore else { return }
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
                self?.showListView()
            })
            .disposed(by: disposeBag)
        
        locationFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterBottomSheet(isCategoryFilter: false)
            })
            .disposed(by: disposeBag)
        
        categoryFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterBottomSheet(isCategoryFilter: true)
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
    }
    
    // MARK: - Helper Methods
    private func updateMapWithStores(_ stores: [PopUpStore]) {
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
    
    
    private func moveCameraToStore(_ store: PopUpStore) {
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
    
    private func updatePopupCardView(for store: PopUpStore) {
        popupCardView.configure(with: store)

        viewModel.output.storeImages
            .subscribe(onNext: { [weak self] images in
                if let image = images[String(store.id)] {
                    self?.popupCardView.configureImage(with: image)
                }
            })
            .disposed(by: disposeBag)

        popupCardView.isHidden = false
    }



    private func showListView() {
            // 기존 코드 유지
            let isListViewVisible = popupListView.frame.origin.y < view.frame.height

            if !isListViewVisible {
                // 리스트뷰가 올라올 때
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

                    // 숨기기
                    self.currentLocationButton.isHidden = true
                    self.listViewButton.isHidden = true
                    self.popupCardView.isHidden = true
                    self.view.layoutIfNeeded()
                }
            } else {
                // 리스트뷰가 내려갈 때
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.snp.updateConstraints { make in
                        make.bottom.equalToSuperview().offset(self.view.frame.height)
                    }
                    self.view.layoutIfNeeded()
                }

                // 다시 보이기
                self.currentLocationButton.isHidden = false
                self.listViewButton.isHidden = false
                self.popupCardView.isHidden = false
            }

            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            popupListView.addGestureRecognizer(panGesture)

             animateListViewToTop()
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

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
          let translation = gesture.translation(in: view)
          let velocity = gesture.velocity(in: view)
          let topPosition = view.safeAreaInsets.top
          let bottomPosition = view.frame.height

          switch gesture.state {
          case .changed:
              let newY = max(topPosition, min(popupListView.frame.origin.y + translation.y, bottomPosition))
              popupListView.frame.origin.y = newY
              gesture.setTranslation(.zero, in: view)

               let progress = (newY - topPosition) / (bottomPosition - topPosition)
               mapView.alpha = progress

          case .ended:
              // 수정: 속도와 위치에 따른 애니메이션 처리
              if velocity.y > 500 || popupListView.frame.origin.y > view.frame.height / 2 {
                  // 아래로 빠르게 스와이프하거나 충분히 내렸을 때
                  animateListViewToBottom()
              } else {
                  // 그 외의 경우 다시 전체 화면으로
                  animateListViewToTop()
              }

          default:
              break
          }
      }
    private func animateListViewToTop() {
          UIView.animate(withDuration: 0.3) {
              self.popupListView.frame.origin.y = self.view.safeAreaInsets.top
              self.mapView.alpha = 0
              self.searchBar.isHidden = false
              self.locationFilterButton.isHidden = false
              self.categoryFilterButton.isHidden = false
              self.currentLocationButton.isHidden = true
              self.listViewButton.isHidden = true
              self.popupCardView.isHidden = true
              self.resizeIndicator.isHidden = false
          }
      }
    private func animateListViewToBottom() {
           UIView.animate(withDuration: 0.3) {
               self.popupListView.frame.origin.y = self.view.frame.height - self.popupListView.frame.height / 2
               self.mapView.alpha = 1
               self.currentLocationButton.isHidden = false
               self.listViewButton.isHidden = false
               self.popupCardView.isHidden = false
               self.resizeIndicator.isHidden = true
           }
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
               // 'X' 가 탭되었을 때의 동작
               if isLocationFilter {
                   viewModel.removeAllLocationFilters()
               } else {
                   viewModel.removeAllCategoryFilters()
               }
               updateFilterButtons()
//               selectedFiltersCollectionView.reloadData()
           } else {
               // 필터 선택 화면 표시
               showFilterBottomSheet(isCategoryFilter: !isLocationFilter)
           }
       }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - GMSMapViewDelegate
extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("마커 탭: \(marker.title ?? "")")

        guard let popupStore = marker.userData as? PopUpStore else {
            return false
        }

        // 팝업 카드를 구성하고 표시합니다.
        popupCardView.configure(with: popupStore)
        popupCardView.isHidden = false

        // 카메라 위치 이동
        let cameraUpdate = GMSCameraUpdate.setTarget(marker.position, zoom: 14.0)
        mapView.animate(with: cameraUpdate)

        // storeImages를 구독하여 해당 store의 이미지를 설정
        viewModel.output.storeImages
            .subscribe(onNext: { [weak self] images in
                if let image = images[String(popupStore.id)] {
                    self?.popupCardView.configureImage(with: image)
                }
            })
            .disposed(by: disposeBag)

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

        let selectedCategories = viewModel.getSelectedCategory()
        let categories = viewModel.getSelectedCategory()
        viewModel.input.categoryFilterChanged.onNext(categories)
        viewModel.input.mapRegionChanged.onNext(GMSCoordinateBounds(
            coordinate: CLLocationCoordinate2D(latitude: roundedSWLat, longitude: roundedSWLon),
            coordinate: CLLocationCoordinate2D(latitude: roundedNELat, longitude: roundedNELon)
        ))
    }
}
