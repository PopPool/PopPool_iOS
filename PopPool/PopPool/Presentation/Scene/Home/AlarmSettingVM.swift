//
//  AlarmSettingVM.swift
//  PopPool
//
//  Created by Porori on 8/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import UserNotifications

final class AlarmSettingVM: ViewModelable {
    struct Input {
        let isAlarmToggled: ControlProperty<Bool>
        let isActivityToggled: ControlProperty<Bool>
        let returnTapped: ControlEvent<Void>
    }
    
    struct Output {
        let returnTapped: Observable<Void>
        let appPushToggled: BehaviorRelay<(Bool, Bool)>
    }
    
    /// appPush를 확인하기 위한 NotificationCenter
    private let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    private var isPermissionOn = BehaviorRelay<(Bool, Bool)>(value: (false, false))
    var disposeBag = DisposeBag()
    
    /// 기기의 알림 설정의 상태를 확인하는 메서드
    /// - Returns: 현재 상태에 맞는 Boolean 값을 반환
    func checkNotificationSetting() -> Observable<Bool> {
        return Observable.create { observer in
            self.center.getNotificationSettings { permission in
                switch permission.authorizationStatus {
                case .authorized:
                    observer.onNext(true)
                default:
                    observer.onNext(false)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    /// 알림 설정을 위한 요청을 보냅니다
    /// - Returns: 요청을 위한 Boolean 값을 반환
    private func requestNotification() -> Observable<Bool> {
        return Observable.create { observer in
            self.center.requestAuthorization(options: self.options) { granted, error in
                observer.onNext(granted)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        input.isAlarmToggled
            .withUnretained(self)
            .subscribe(onNext: { (owner, isOn) in
                owner.checkNotificationSetting()
                    .flatMapLatest { isAuthorized in
                        if isOn && !isAuthorized {
                            owner.isPermissionOn.accept((isOn, isAuthorized))
                            return owner.requestNotification()
                        } else {
                            owner.isPermissionOn.accept((isOn, isAuthorized))
                            return .just(isAuthorized)
                        }
                    }
                    .subscribe(onNext: { isAuthorized in
                        owner.isPermissionOn.accept((isOn, isAuthorized))
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(
            returnTapped: input.returnTapped.asObservable(),
            appPushToggled: isPermissionOn
        )
    }
}
