//
//  alarmSettingVC.swift
//  PopPool
//
//  Created by Porori on 8/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class AlarmSettingVC: BaseViewController {
    
    // MARK: - Components
    
    let headerView = HeaderViewCPNT(title: "알림설정", style: .icon(nil))
    let serviceAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "서비스 알림",
        size: .large(subtitle: "팝풀의 다양한 이벤트와 혜택을 알려드려요.", image: nil))
    
    let activityAlarm: ListTitleViewCPNT = ListTitleViewCPNT(
        title: "활동 알림",
        size: .large(subtitle: "내 활동에 대한 반응을 알려드려요.", image: nil))
    
    let appPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "앱 푸시",
        subTitle: "", style: .toggle)
    
    let activityPush: ListInfoButtonCPNT = ListInfoButtonCPNT(
        infoTitle: "활동 알림",
        subTitle: "", style: .toggle)
    
    let topSpaceView = UIView()
    let secondSpaceView = UIView()
    let dividerView = UIView()
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    let viewModel: AlarmSettingVM
    
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
        headerView.leftBarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        appPush.actionToggle.rx.isOn
            .subscribe(onNext: { [weak self] isOn in
                self?.viewModel.checkSetting(isOn: isOn)
                    .subscribe(onNext: { [weak self] isAuthorized in
                        print("허가 여부", isAuthorized)
                        if !isAuthorized {
                            self?.createSettingAlert(isOn: isOn)
                        }
                    })
                    .disposed(by: self?.disposeBag ?? DisposeBag())
            })
            .disposed(by: disposeBag)
        
        activityPush.actionToggle.rx.isOn
            .subscribe(onNext: { [weak self] isOn in
                self?.createSettingAlert(isOn: isOn)
            })
            .disposed(by: disposeBag)
    }
    
    private func createSettingAlert(isOn: Bool) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "알림 설정",
                message: """
            기기의 알림 설정이 껴져있습니다.\n휴대푠 설정 > 알림 > 팝풀에서\n설정을 변경해주세요.
            """,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { [weak self] _ in
                self?.appPush.actionToggle.setOn(!isOn, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { _ in
                let url = URL(string: UIApplication.openSettingsURLString)
                if isOn {
                    UIApplication.shared.open(url!)
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
