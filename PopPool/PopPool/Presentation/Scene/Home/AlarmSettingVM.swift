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

class AlarmSettingVM: ViewModelable {
    struct Input {
        var isAlarmToggled: ControlEvent<Bool>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func checkSetting(isOn: Bool) -> Observable<Bool> {
        return Observable.create { observer in
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings { setting in
                if setting.authorizationStatus != .authorized {
                    observer.onNext(false)
                    observer.onCompleted()
                } else if setting.authorizationStatus == .authorized {
                    print("화면 설정 실패")
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
