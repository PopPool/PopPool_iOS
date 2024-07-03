//
//  LoginVM.swift
//  PopPool
//
//  Created by Porori on 6/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginVM: ViewModelable {

    /// LoginVC의 입력 이벤트
    struct Input {
        /// 뒤로 돌아가기 버튼 탭
        var tourButtonTapped: ControlEvent<Void>
        /// 카카오 로그인 버튼 탭
        var kakaoLoginButtonTapped: ControlEvent<Void>
        /// 애플 로그인 버튼 탭
        var appleLoginButtonTapped: ControlEvent<Void>
        /// 문의 버튼 탭
        var inquryButtonTapped: ControlEvent<Void>
    }
    
    /// LoginVC으로 출력 이벤트
    struct Output {
        let showLoginBottomSheet: Observable<SocialTYPE>
        let moveToInquryPage: Observable<Void>
        let moveToSignUpPage: ControlEvent<Void>
    }
    
    private var deliverData = BehaviorRelay(value: UserDefaults.standard.integer(forKey: "serviceValue"))
    var dataObservable: Observable<Int> {
        return deliverData.asObservable()
    }
    private let showLoginPlatformSubject = PublishSubject<SocialTYPE>()
    private let moveToInquirySubject = PublishSubject<Void>()
    private var userdefault = UserDefaults.standard
    var disposeBag: DisposeBag = DisposeBag()
    
    
    /// LoginVC로 부터 받은 Input을 Output으로 변환하는 메서드
    /// - Parameter input: LoginVC에서 발생한 입력에 대한 이벤트 구조체
    /// - Returns: LoginVC에 발생할 출력 구조체
    func transform(input: Input) -> Output {
        // 돌아보기 버튼 입력
        input.tourButtonTapped
            .subscribe { result in
                print("로그인없이 메인 화면으로 이동합니다.")
                ToastMSGManager.createToast(message: "로그인없이 메인 화면으로 이동합니다.")
                // 🚨 로그인 처리없이 메인 화면으로 이동 예정 - 수정 필요
            } onError: { error in
                print("뒤돌아가기 버튼에서 오류가 발생했습니다.")
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        // 카카오 로그인 버튼 입력
//        input.kakaoLoginButtonTapped
//            .map { SocialTYPE.kakao }
//            .bind(to: showLoginPlatformSubject)
//            .disposed(by: disposeBag)
        
        // 애플 로그인 버튼 입력
        input.appleLoginButtonTapped
            .map { SocialTYPE.apple }
            .bind(to: showLoginPlatformSubject)
            .disposed(by: disposeBag)
        
        input.inquryButtonTapped
            .subscribe { complete in
                print("문의하기 화면으로 이동")
                ToastMSGManager.createToast(message: "문의하기 화면은 구현 중에 있습니다")
                // 문의하기 페이지 구현 이후 연결 필요
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        showLoginPlatformSubject
            .subscribe(onNext: { [weak self] platform in
                self?.setLoginServiceChecker(service: platform)
            })
            .disposed(by: disposeBag)

        return Output(
            showLoginBottomSheet: showLoginPlatformSubject,
            moveToInquryPage: moveToInquirySubject,
            moveToSignUpPage: input.kakaoLoginButtonTapped
        )
    }
    
    private func setLoginServiceChecker(service: SocialTYPE) {
        var serviceValue: Int
        
        switch service {
        case .kakao:
            serviceValue = 0
            userdefault.setValue(serviceValue, forKey: "kakao")
            
        case .apple:
            serviceValue = 1
            userdefault.setValue(serviceValue, forKey: "apple")
        }
        deliverData.accept(serviceValue)
    }
}
