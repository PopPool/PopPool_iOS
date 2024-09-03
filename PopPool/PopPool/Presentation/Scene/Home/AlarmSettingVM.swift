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
        let displayAlert: BehaviorRelay<(Bool, Bool)>
    }
    
    private let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    private var isPermissionOn = BehaviorRelay<(Bool, Bool)>(value: (false, false))
    var disposeBag = DisposeBag()
    
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
                print("===버튼 토글 O")
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
                        // 여기서 현재 설정 상태 트래킹?
                        print("상태 트래킹", isAuthorized)
                        owner.isPermissionOn.accept((isOn, isAuthorized))
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
//        let alarmStatus = input.isAlarmToggled
//            .flatMapLatest { isOn in
//                if isOn {
//                    print("====버튼 토글 O")
//                    return self.checkNotificationSetting()
//                        .flatMapLatest { isAuthorized -> Observable<(Bool, Bool)> in
//                            if !isAuthorized {
//                                print("버튼 토글 값", isOn)
//                                print("알람 설정 여부", isAuthorized)
//                                return self.requestNotification().map { (isOn, $0) }
//                            } else {
//                                print("버튼 토글 값2", isOn)
//                                print("알람 설정 여부2", isAuthorized)
//                                return .just((isOn, isAuthorized))
//                            }
//                        }
//                } else {
//                    print("====버튼 토글 x")
//                    return self.checkNotificationSetting()
//                        .flatMapLatest { isAuthorized -> Observable<(Bool, Bool)> in
//                            if !isAuthorized {
//                                print("버튼 토글 값3", isOn)
//                                print("알람 설정 여부3", isAuthorized)
//                                return .just((isOn, isAuthorized))
//                            } else {
//                                print("알람은 켜져있는데 버튼 토글은 안된 상황")
//                                // 알림 설정을 끄는 기능을 추가 해야한다.
//                                print("허용 여부", isAuthorized)
//                                return .just((isOn, isAuthorized))
//                            }
//                        }
//                }
//            }
        
        return Output(
            returnTapped: input.returnTapped.asObservable(),
            displayAlert: isPermissionOn
        )
    }
}
