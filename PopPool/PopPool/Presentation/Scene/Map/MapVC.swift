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
       let mapView = GMSMapView(frame: .zero, camera: camera)
       return mapView
   }()

   private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
       searchBar.placeholder = "팝업스토어명, 지역을 입력해보세요"
       searchBar.backgroundColor = .white
       searchBar.layer.cornerRadius = 8
       searchBar.clipsToBounds = true
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
       tableView.isHidden = true
       return tableView
   }()

   // MARK: - Initialization
   init(viewModel: MapVM) {
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
   }


   // MARK: - Setup Methods
   private func setupUI() {
       view.addSubview(mapView)
       view.addSubview(searchBar)
       view.addSubview(filterStackView)
       view.addSubview(currentLocationButton)
       view.addSubview(listViewButton)
       view.addSubview(popupCardView)
       view.addSubview(popupListView)

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
           make.edges.equalToSuperview()
       }
   }

   private func bindViewModel() {
       // 검색 기능 제거
       /*
       searchBar.rx.text.orEmpty
           .bind(to: viewModel.input.searchQuery)
           .disposed(by: disposeBag)
       */

       // 필터된 스토어를 기반으로 지도에 팝업 스토어 업데이트
       viewModel.output.filteredStores
           .subscribe(onNext: { [weak self] stores in
               self?.updateMapWithStores(stores)
           })
           .disposed(by: disposeBag)

       // 키보드 내리기
       let tapGesture = UITapGestureRecognizer()
       mapView.addGestureRecognizer(tapGesture)

       tapGesture.rx.event
           .subscribe(onNext: { [weak self] _ in
               self?.view.endEditing(true)
           })
           .disposed(by: disposeBag)

       // 현재 위치 버튼
       currentLocationButton.rx.tap
           .bind(to: viewModel.input.currentLocationRequested)
           .disposed(by: disposeBag)

       listViewButton.rx.tap
           .subscribe(onNext: { [weak self] in
               self?.showListView()
           })
           .disposed(by: disposeBag)

       // 필터 버튼 탭 이벤트
       locationFilterButton.rx.tap
              .subscribe(onNext: { [weak self] in
                  self?.showFilterBottomSheet()
              })
              .disposed(by: disposeBag)

          categoryFilterButton.rx.tap
              .subscribe(onNext: { [weak self] in
                  self?.showFilterBottomSheet()
              })
              .disposed(by: disposeBag)


       // 팝업 리스트 데이터를 바인딩하여 테이블 뷰를 업데이트
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

       // 에러 메시지 표시
       viewModel.output.errorMessage
           .subscribe(onNext: { [weak self] message in
               self?.showError(message)
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
       popupListView.isHidden = false

       UIView.animate(withDuration: 0.3) {
              self.popupListView.frame.origin.y = self.view.frame.height / 2
          }
       // 리사이즈 인디케이터 추가
       let resizeIndicator = UIView()
          resizeIndicator.backgroundColor = .lightGray
          resizeIndicator.layer.cornerRadius = 2
          popupListView.addSubview(resizeIndicator)

          resizeIndicator.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(10)
              make.centerX.equalToSuperview()
              make.width.equalTo(40)
              make.height.equalTo(4)
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
       present(filterVC, animated: true, completion: nil)
   }
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .changed:
            let newY = max(view.safeAreaInsets.top, popupListView.frame.origin.y + translation.y)
            popupListView.frame.origin.y = newY
            gesture.setTranslation(.zero, in: view)
        case .ended:
            let velocity = gesture.velocity(in: view)
            if velocity.y > 0 && popupListView.frame.origin.y > view.frame.height * 0.75 {
                // 아래로 스와이프하여 닫기
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = self.view.frame.height
                } completion: { _ in
                    self.popupListView.isHidden = true
                }
            } else if velocity.y < 0 || popupListView.frame.origin.y < view.frame.height * 0.25 {
                // 위로 스와이프하여 전체 화면으로 확장
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = self.view.safeAreaInsets.top
                }
            } else {
                // 중간 위치로 되돌리기
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = self.view.frame.height / 2
                }
            }
        default:
            break
        }
    }

}
