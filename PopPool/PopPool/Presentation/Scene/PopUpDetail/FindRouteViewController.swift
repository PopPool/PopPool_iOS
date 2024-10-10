import UIKit
import GoogleMaps
import SnapKit

class FindRouteViewController: UIViewController {

    var popupStoreLatitude: Double?
    var popupStoreLongitude: Double?

    private let mapView = GMSMapView()

    private let directionsLabel: UILabel = {
        let label = UILabel()
        label.text = "지도 앱으로 \n바로 찾아볼까요?"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "찾아가는 길"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()

    private let naverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "defaultImage"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    private let kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "defaultImage"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    private let tmapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "defaultImage"), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setMapRegion()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.addSubview(naverButton)
        view.addSubview(kakaoButton)
        view.addSubview(tmapButton)
        view.addSubview(directionsLabel)

    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)

        }
        directionsLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
        }

        let buttonSize: CGFloat = 30
        let buttonSpacing: CGFloat = 16

        naverButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(90)
            make.width.height.equalTo(buttonSize)
        }

        kakaoButton.snp.makeConstraints { make in
            make.top.equalTo(naverButton)
            make.trailing.equalToSuperview().inset(60)
            make.width.height.equalTo(buttonSize)
        }

        tmapButton.snp.makeConstraints { make in
            make.top.equalTo(naverButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(buttonSize)
        }
    }

    private func setMapRegion() {
        guard let latitude = popupStoreLatitude, let longitude = popupStoreLongitude else { return }
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
        mapView.camera = camera

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.map = mapView
    }

    @objc private func openNaverMap() {
        guard let latitude = popupStoreLatitude, let longitude = popupStoreLongitude else { return }
        URLSchemeService.openApp(.naverMap, latitude: latitude, longitude: longitude)
    }

    @objc private func openKakaoMap() {
        guard let latitude = popupStoreLatitude, let longitude = popupStoreLongitude else { return }
        URLSchemeService.openApp(.kakaoMap, latitude: latitude, longitude: longitude)
    }

    @objc private func openTMap() {
        guard let latitude = popupStoreLatitude, let longitude = popupStoreLongitude else { return }
        URLSchemeService.openApp(.tMap, latitude: latitude, longitude: longitude)
    }

    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
}
