import UIKit
import GoogleMaps
import SnapKit

class FindRouteViewController: UIViewController {

    var popupStoreLatitude: Double?
    var popupStoreLongitude: Double?

    private let mapView = GMSMapView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "길 찾기"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let naverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("네이버 지도", for: .normal)
        button.addTarget(self, action: #selector(openNaverMap), for: .touchUpInside)
        return button
    }()

    private let kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카카오맵", for: .normal)
        button.addTarget(self, action: #selector(openKakaoMap), for: .touchUpInside)
        return button
    }()

    private let tmapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("T맵", for: .normal)
        button.addTarget(self, action: #selector(openTMap), for: .touchUpInside)
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
        view.addSubview(naverButton)
        view.addSubview(kakaoButton)
        view.addSubview(tmapButton)
    }

    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        naverButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        kakaoButton.snp.makeConstraints { make in
            make.top.equalTo(naverButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        tmapButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
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
}
