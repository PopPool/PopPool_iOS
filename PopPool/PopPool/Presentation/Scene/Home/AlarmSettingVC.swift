//
//  alarmSettingVC.swift
//  PopPool
//
//  Created by Porori on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol ActivityAlarmDelegate: AnyObject {
    func activityToggled(image: UIImage?)
}

final class AlarmSettingVC: BaseViewController {
    
    // MARK: - Components
    
    private let headerView = HeaderViewCPNT(title: "알림설정", style: .icon(nil))
    private let serviceAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "서비스 알림",
        size: .large(subtitle: "팝풀의 다양한 이벤트와 혜택을 알려드려요.", image: nil))
    
    private let activityAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "활동 알림",
        size: .large(subtitle: "내 활동에 대한 반응을 알려드려요.", image: nil))
    
    private let appPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "앱 푸시",
        subTitle: "", style: .toggle)
    
    private let activityPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "활동 알림",
        subTitle: "", style: .toggle)
    
    private let topSpaceView = UIView()
    private let secondSpaceView = UIView()
    private let dividerView = UIView()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: AlarmSettingVM
    var delegate: ActivityAlarmDelegate?
    
    // MARK: - Initializer
    
    init(viewModel: AlarmSettingVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    // MARK: - Methods
    private func bind() {
        NotificationCenter.default.rx.notification(
            UIApplication.didBecomeActiveNotification)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.didBecomeActive()
            })
            .disposed(by: disposeBag)
        
        let input = AlarmSettingVM.Input(
            isAlarmToggled: appPush.actionToggle.rx.isOn,
            isActivityToggled: activityPush.actionToggle.rx.isOn,
            returnTapped: headerView.leftBarButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.returnTapped
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.appPushToggled
            .withUnretained(self)
            .subscribe(onNext: { (owner, status) in
                let (isOn, isAuthorized) = status
                if isOn && !isAuthorized {
                    owner.createSettingAlert()
                }
            })
            .disposed(by: disposeBag)
        
        output.activityToggled
            .withUnretained(self)
            .subscribe(onNext: { (owner, isOn) in
                print("켜짐", isOn)
                if isOn {
                    owner.delegate?.activityToggled(image: UIImage(systemName: "lasso"))
                } else {
                    owner.delegate?.activityToggled(image: UIImage(systemName: "photo"))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 사용자가 설정 페이지의 알람 설정을 껐는지 확인, 상태에 맞춰 switch를 변경하는 메서드
    private func didBecomeActive() {
        viewModel.checkNotificationSetting()
            .withUnretained(self)
            .subscribe(onNext: { (owner, permission) in
                DispatchQueue.main.async {
                    if owner.appPush.actionToggle.isOn && !permission {
                        owner.appPush.actionToggle.setOn(false, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 기기 설정 페이지로 이동하는 안내 메시지
    private func createSettingAlert() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "알림 설정",
                message: "기기의 알림 설정이 껴져있습니다.\n휴대푠 설정 > 알림 > 팝풀에서\n설정을 변경해주세요.",
                preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(title: "취소",
                              style: .cancel,
                              handler: { _ in
                                  if let isOn = self?.appPush.actionToggle.isOn {
                                      self?.appPush.actionToggle
                                          .setOn(!isOn, animated: true)
                                  }
                              }))
            
            alert.addAction(
                UIAlertAction(title: "설정",
                              style: .default,
                              handler: { _ in
                                  let url = URL(string: UIApplication.openSettingsURLString)
                                  if let url = url {
                                      // 디바이스 설정 화면으로 이동
                                      UIApplication.shared.open(url)
                                  }
                              }))
            
            self?.present(alert, animated: true)
        }
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
