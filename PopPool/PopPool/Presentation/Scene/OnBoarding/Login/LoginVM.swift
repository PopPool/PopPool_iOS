//
//  LoginVM.swift
//  PopPool
//
//  Created by Porori on 6/27/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginVM: ViewModelable {

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
        
    }
    
    var disposeBag: DisposeBag = DisposeBag()

    /// LoginVC로 부터 받은 Input을 Output으로 변환하는 메서드
    /// - Parameter input: LoginVC에서 발생한 입력에 대한 이벤트 구조체
    /// - Returns: LoginVC에 발생할 출력 구조체
    func transform(input: Input) -> Output {
        // 돌아보기 버튼 입력
        input.tourButtonTapped
            .subscribe { result in
                print("로그인없이 메인 화면으로 이동합니다.")
                // 🚨 로그인 처리없이 메인 화면으로 이동 예정 - 수정 필요
            } onError: { error in
                print("뒤돌아가기 버튼에서 오류가 발생했습니다.")
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        // 카카오 로그인 버튼 입력
        input.kakaoLoginButtonTapped
            .subscribe { transition in
                print("카카오 로그인 화면 전환이 됩니다.")
            } onError: { error in
                print("로그인 버튼에서 오류가 발생했습니다.")
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        // 애플 로그인 버튼 입력
        input.appleLoginButtonTapped
            .subscribe { transition in
                print("애플 로그인 화면 전환")
            } onError: { error in
                print("애플 로그인 오류가 발생했습니다.")
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
        
        input.inquryButtonTapped
            .subscribe { transition in
                print("문의하기 화면으로 이동")
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)

        return Output()
    }
}
