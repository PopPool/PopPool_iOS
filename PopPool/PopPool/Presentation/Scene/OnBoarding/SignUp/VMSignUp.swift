//
//  VMSignUp.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class VMSignUp: ViewModelable {
    
    /// 입력 이벤트
    struct Input {
        /// Sign Up Step1 primary button  탭 이벤트
        var tap_step1_primaryButton: ControlEvent<Void>
        /// Sign Up Step2 primary button  탭 이벤트
        var tap_step2_primaryButton: ControlEvent<Void>
        /// Sign Up Step3 primary button  탭 이벤트
        var tap_step3_primaryButton: ControlEvent<Void>
        /// 약관 동의 변경을 전달하는 Subject
        var didChagneTerms: PublishSubject<[Bool]>
    }
    
    /// 출력 이벤트
    struct Output {
        /// 페이지 인덱스 증가 이벤트를 방출하는 Subject
        var increasePageIndex: PublishSubject<Int>
        /// Step 1의 주요 버튼 활성/비활성 상태를 방출하는 Subject
        var step1_primaryButton_isEnabled: PublishSubject<Bool>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    /// 현재 페이지 인덱스를 관리하는 BehaviorRelay
    private var pageIndex: BehaviorRelay<Int> = .init(value: 0)
    
    /// 입력을 출력으로 변환하는 메서드
    ///
    /// - Parameter input: 입력 구조체
    /// - Returns: 출력 구조체
    func transform(input: Input) -> Output {
        
        let increasePageIndex: PublishSubject<Int> = .init()
        let step1_primaryButton_isEnabled: PublishSubject<Bool> = .init()
        
        // 약관 동의 변경 이벤트 처리
        input.didChagneTerms.asObserver()
            .subscribe(onNext: { isCheck in
                if isCheck[0] && isCheck[1] && isCheck[2] {
                    step1_primaryButton_isEnabled.onNext(true)
                } else {
                    step1_primaryButton_isEnabled.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        // Step 1 primary button 탭 이벤트
        input.tap_step1_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.pageIndex.accept(owner.pageIndex.value + 1)
                increasePageIndex.onNext(owner.pageIndex.value)
            }
            .disposed(by: disposeBag)
        
        // Step 2 primary button 탭 이벤트 처리
        input.tap_step2_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.pageIndex.accept(owner.pageIndex.value + 1)
                increasePageIndex.onNext(owner.pageIndex.value)
            }
            .disposed(by: disposeBag)
        
        // Step 3 primary button 탭 이벤트 처리
        input.tap_step3_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.pageIndex.accept(owner.pageIndex.value + 1)
                increasePageIndex.onNext(owner.pageIndex.value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            increasePageIndex: increasePageIndex,
            step1_primaryButton_isEnabled: step1_primaryButton_isEnabled
        )
    }
}
