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
                if setting.authorizationStatus == .authorized {
                    print("화면 설정 가능")
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    center.requestAuthorization(options: [.alert, .badge]) { granted, error in
                        print("설정 필요", granted)
                        observer.onNext(granted)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
