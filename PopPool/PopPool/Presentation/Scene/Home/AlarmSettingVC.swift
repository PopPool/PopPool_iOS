//
//  alarmSettingVC.swift
//  PopPool
//
//  Created by Porori on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift

final class AlarmSetting: UIViewController {
    
//    enum Section {
//        case service
//        case activity
//        
//        var sectionTitle: String {
//            switch self {
//            case .activity: return "서비스 알림"
//            case .service: return "활동 알림"
//            }
//        }
//        
//        var sectionDescription: String {
//            switch self {
//            case .activity: return "팝풀의 당야한 이벤트와 혜택을 알려드려요."
//            case .service: return "내 활동에 대한 반응을 알려드려요."
//            }
//        }
//    }
    
    let headerView = HeaderViewCPNT(title: "알림설정", style: .icon(nil))
    let serviceAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "서비스 알림",
        size: .large(subtitle: "팝풀의 다양한 이벤트와 혜택을 알려드려요.", image: nil))
    
    let activityAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "활동 알림",
        size: .large(subtitle: "내 활동에 대한 반응을 알려드려요.", image: nil))
    
    let appPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "앱푸시",
        subTitle: "이건 뭐야", style: .toggle)
    
    let activityPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "활동 알림",
        subTitle: "이건 뭐야", style: .toggle)
    
    let topSpaceView = UIView()
    let secondSpaceView = UIView()
    let dividerView = UIView()
    let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        headerView.leftBarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                print("뒤돌아가기")
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        view.backgroundColor = .g50
        dividerView.backgroundColor = .g100
        navigationController?.navigationBar.isHidden = true
        serviceAlarm.rightButton.isHidden = true
        activityAlarm.rightButton.isHidden = true
        
        appPush.profileImageView.isHidden = true
        activityPush.profileImageView.isHidden = true
    }
    
    private func setUpConstraint() {
        view.addSubview(headerView)
        view.addSubview(topSpaceView)
        view.addSubview(serviceAlarm)
        view.addSubview(appPush)
        
        view.addSubview(secondSpaceView)
        view.addSubview(activityAlarm)
        view.addSubview(activityPush)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        topSpaceView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        serviceAlarm.snp.makeConstraints { make in
            make.top.equalTo(topSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        appPush.snp.makeConstraints { make in
            make.top.equalTo(serviceAlarm.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(appPush.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small100)
            make.leading.trailing.equalToSuperview()
        }
        
        secondSpaceView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        activityAlarm.snp.makeConstraints { make in
            make.top.equalTo(secondSpaceView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        activityPush.snp.makeConstraints { make in
            make.top.equalTo(activityAlarm.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}
