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
//        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
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
        view.addSubview(popupListView)
        view.addSubview(searchBar)
        view.addSubview(filterStackView)
        view.addSubview(currentLocationButton)
        view.addSubview(listViewButton)
        view.addSubview(popupCardView)
//        view.addSubview(popupListView)

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
            make.bottom.equalToSuperview().offset(view.frame.height) // 화면 아래에 숨겨둠
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
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.searchQuery)
            .disposed(by: disposeBag)

        viewModel.output.filteredStores
            .subscribe(onNext: { [weak self] stores in
                self?.updateMapWithStores(stores)
            })
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        mapView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
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
                self?.showFilterBottomSheet()
            })
            .disposed(by: disposeBag)

        categoryFilterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showFilterBottomSheet()
            })
            .disposed(by: disposeBag)

        viewModel.output.filteredStores
            .bind(to: popupListView.rx.items(cellIdentifier: PopupListCell.identifier, cellType: PopupListCell.self)) { index, store, cell in
                cell.configure(with: store)
            }
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
        print("List view button tapped, y position: \(popupListView.frame.origin.y)")

        if popupListView.frame.origin.y >= view.frame.height {
            // 뷰가 화면 아래에 있는 경우, 위치를 초기화하고 애니메이션으로 올림
            popupListView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(view.frame.height / 2) // 화면 중간 위치로 초기화
            }
            view.layoutIfNeeded() // 위치를 즉시 업데이트

            popupListView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.popupListView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview() // 화면 하단에 맞춤
                }
                self.popupListView.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            // 이미 화면에 올라와 있는 상태에서 단순히 위치를 조정
            UIView.animate(withDuration: 0.3) {
                self.popupListView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview() // 화면 하단에 맞춤
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
        present(filterVC, animated: true, completion: nil)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let topPosition = view.safeAreaInsets.top // 서치바 바로 아래
        let bottomPosition = view.frame.height // 화면 하단 위치

        switch gesture.state {
        case .changed:
            let newY = max(topPosition, min(popupListView.frame.origin.y + translation.y, bottomPosition))
            popupListView.frame.origin.y = newY
            gesture.setTranslation(.zero, in: view)

        case .ended:
            let velocity = gesture.velocity(in: view)

            if velocity.y > 0 {
                // 아래로 내려가는 경우
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = bottomPosition
                    self.searchBar.isHidden = false
                    self.filterStackView.isHidden = false
                    self.resizeIndicator.isHidden = false
                }
            } else {
                // 위로 올라가는 경우
                UIView.animate(withDuration: 0.3) {
                    self.popupListView.frame.origin.y = topPosition
                    self.popupListView.snp.remakeConstraints { make in
                        make.top.equalToSuperview()
                        make.leading.trailing.bottom.equalToSuperview()
                    }
                    self.view.layoutIfNeeded()

//                    self.searchBar.isHidden = true
//                    self.filterStackView.isHidden = true
                    self.resizeIndicator.isHidden = true
                }
            }

        default:
            break
        }
    }
}
