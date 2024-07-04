//
//  SignUpVM.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpVM: ViewModelable {
    
    /// 입력 이벤트
    struct Input {
        // MARK: - HeaderInput
        /// header cancelButton 탭 이벤트
        var tap_header_cancelButton: ControlEvent<Void>
        /// header backButton 탭 이벤트
        var tap_header_backButton: ControlEvent<Void>
        
        // MARK: - Step 1 Input
        /// Sign Up Step1 primary button  탭 이벤트
        var tap_step1_primaryButton: ControlEvent<Void>
        /// 약관 동의 변경을 전달하는 Subject
        var event_step1_didChangeTerms: PublishSubject<[Bool]>
        /// 약관 버튼 탭 이벤트
        var tap_step1_termsButton: PublishSubject<SignUpStep1View.Terms>
        
        // MARK: - Step 2 Input
        /// Sign Up Step2 primary button  탭 이벤트
        var tap_step2_primaryButton: ControlEvent<Void>
        /// Sign Up Step2 중복확인 button  탭 이벤트
        var tap_step2_nickNameCheckButton: ControlEvent<Void>
        /// Sign Up Step2 유효한 닉네임 전달 이벤트
        var event_step2_availableNickName: PublishSubject<String?>
        
        // MARK: - Step 3 Input
        /// Sign Up Step3 primary button  탭 이벤트
        var tap_step3_primaryButton: ControlEvent<Void>
        /// Sign Up Step3 secondary button  탭 이벤트
        var tap_step3_secondaryButton: ControlEvent<Void>
        
        // MARK: - Step 4 Input
        /// 관심사 변경을 전달하는 Subject
        var event_step3_didChangeInterestList: Observable<[String]>
        /// step 4 gender segmentedControl 이벤트
        var event_step4_didSelectGender: ControlProperty<Int>
        /// step 4 나이 설정 버튼 탭 이벤트
        var tap_step4_ageButton: ControlEvent<Void>
        /// Sign Up Step4 secondary button  탭 이벤트
        var tap_step4_secondaryButton: ControlEvent<Void>
        /// Sign Up Step4 나이 선택 후 확인 이벤트
        var event_step4_didSelectAge: PublishSubject<Int>
    }
    
    /// 출력 이벤트
    struct Output {
        // MARK: - Common OutPut
        /// 페이지 인덱스 증가 이벤트를 방출하는 Subject
        var increasePageIndex: PublishSubject<Int>
        /// 페이지 인덱스 감소 이벤트를 방출하는 Subject
        var decreasePageIndex: PublishSubject<Int>
        /// 이전 화면으로 이동
        var moveToRecentVC: ControlEvent<Void>
        
        // MARK: - Step 1 OutPut
        /// Step 1의 primary button 활성/비활성 상태를 방출하는 Subject
        var step1_primaryButton_isEnabled: PublishSubject<Bool>
        /// terms vc로 이동
        var step1_moveToTermsVC: PublishSubject<SignUpStep1View.Terms>
        
        // MARK: - Step 2 OutPut
        /// nickName 중복 여부 상태를 방출하는 Subject
        var step2_isDuplicate: PublishSubject<Bool>
        /// Step 2의 primary button 활성/비활성 상태를 방출하는 Subject
        var step2_primaryButton_isEnabled: PublishSubject<Bool>
        /// 유효한 닉네임 전달 이벤트
        var step2_fetchUserNickname: PublishSubject<String>
        
        // MARK: - Step 3 OutPut
        /// 카테고리 리스트를 가져오는 Subject
        var step3_fetchCategoryList: PublishSubject<[String]>
        /// Step 3의 primary button 활성/비활성 상태를 방출하는 Subject
        var step3_primaryButton_isEnabled: PublishSubject<Bool>
        
        // MARK: - Step 4 OutPut
        /// Step 4의 나이선택 모달로 이동
        var step4_moveToAgeSelectVC: PublishSubject<(ClosedRange<Int>, Int)>
    }
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    /// 현재 페이지 인덱스를 관리하는 BehaviorRelay
    private var pageIndex: BehaviorRelay<Int> = .init(value: 0)
    
    /// 현재 페이지 인덱스의 증,감소를 관리하는 PublishSubject
    private let pageIndexIncreaseObserver: PublishSubject<Int> = .init()
    private let pageIndexDecreaseObserver: PublishSubject<Int> = .init()
    
    /// 올바른 유저의 닉네임을 관리하는 subject
    private let userNickName: PublishSubject<String> = .init()
    
    /// 나이 Picker 범위
    private let ageRange = (14...100)
    /// 유저 나이
    private var selectAgeIndex: Int = 16
    
    // MARK: - init
    init() {
        
    }
    
    // MARK: - transform
    /// 입력을 출력으로 변환하는 메서드
    ///
    /// - Parameter input: 입력 구조체
    /// - Returns: 출력 구조체
    func transform(input: Input) -> Output {
        
        let step1_primaryButton_isEnabled: PublishSubject<Bool> = .init()
        
        let step2_isDuplicate: PublishSubject<Bool> = .init()
        let step2_primaryButton_isEnabled: PublishSubject<Bool> = .init()
        
        let step3_primaryButton_isEnabled: PublishSubject<Bool> = .init()
        let fetchCategoryList: PublishSubject<[String]> = .init()
        
        let step4_moveToAgeSelectVC: PublishSubject<(ClosedRange<Int>, Int)> = .init()

        // MARK: - Common transform
        // tap_header_cancelButton 이벤트 처리
        input.tap_header_cancelButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                print("tap_header_cancelButton")
            }
            .disposed(by: disposeBag)
        
        // tap_header_backButton 이벤트 처리
        input.tap_header_backButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.decreasePageIndex()
            }
            .disposed(by: disposeBag)
        
        // MARK: - Step 1 transform
        // 약관 동의 변경 이벤트 처리
        input.event_step1_didChangeTerms.asObserver()
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
                owner.increasePageIndex()
            }
            .disposed(by: disposeBag)
        
        // MARK: - Step 2 transform
        // Step 2 primary button 탭 이벤트 처리
        input.tap_step2_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.increasePageIndex()
                // 네트워크 사용으로 수정 필요
                fetchCategoryList.onNext([
                    "패션",
                    "라이프스타일",
                    "뷰티",
                    "음식/요리",
                    "예술",
                    "반려동물",
                    "여행",
                    "엔터테인먼트",
                    "애니메이션",
                    "키즈",
                    "스포츠",
                    "게임",
                ])
            }
            .disposed(by: disposeBag)
        
        // Step2 중복확인 버튼 이벤트 처리
        input.tap_step2_nickNameCheckButton
            .subscribe { _ in
                // 네트워크 사용으로 수정 필요
                step2_isDuplicate.onNext(false)
            }
            .disposed(by: disposeBag)
        
        // Step2 nickName Validation 상태 이벤트 처리
        input.event_step2_availableNickName
            .withUnretained(self)
            .subscribe(onNext: { (owner, nickname) in
                if let nickname = nickname {
                    owner.userNickName.onNext(nickname)
                    step2_primaryButton_isEnabled.onNext(true)
                } else {
                    owner.userNickName.onNext("error")
                    step2_primaryButton_isEnabled.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - Step 3 transform
        // 관심사 리스트 변경 이벤트 처리
        input.event_step3_didChangeInterestList
            .subscribe { list in
                step3_primaryButton_isEnabled.onNext(list.count > 0 ? true : false)
            } onError: { error in
                print("관심사 선택 중 알 수 없는 오류가 발생하였습니다.")
            }
            .disposed(by: disposeBag)

        // Step 3 primary button 탭 이벤트 처리
        input.tap_step3_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.increasePageIndex()
            }
            .disposed(by: disposeBag)
        
        // Step 3 secondary button 탭 이벤트 처리
        input.tap_step3_secondaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.increasePageIndex()
            }
            .disposed(by: disposeBag)
        
        // MARK: - Step 4 transform
        // Step 4 성별 segmented Control 이벤트 처리
        input.event_step4_didSelectGender
            .subscribe { selectedIndex in
//                print(selectedIndex)
            }
            .disposed(by: disposeBag)
        
        // Step 4 ageButton Tap 이벤트 처리
        input.tap_step4_ageButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                step4_moveToAgeSelectVC.onNext((owner.ageRange, owner.selectAgeIndex))
            }
            .disposed(by: disposeBag)
        
        // Step 4 age select 이벤트 처리
        input.event_step4_didSelectAge
            .withUnretained(self)
            .subscribe { (owner, index) in
                owner.selectAgeIndex = index
            }
            .disposed(by: disposeBag)
        
        return Output(
            increasePageIndex: pageIndexIncreaseObserver,
            decreasePageIndex: pageIndexDecreaseObserver,
            moveToRecentVC: input.tap_header_cancelButton,
            step1_primaryButton_isEnabled: step1_primaryButton_isEnabled,
            step1_moveToTermsVC: input.tap_step1_termsButton,
            step2_isDuplicate: step2_isDuplicate,
            step2_primaryButton_isEnabled: step2_primaryButton_isEnabled,
            step2_fetchUserNickname: userNickName,
            step3_fetchCategoryList: fetchCategoryList,
            step3_primaryButton_isEnabled: step3_primaryButton_isEnabled,
            step4_moveToAgeSelectVC: step4_moveToAgeSelectVC
        )
    }
}

// MARK: - Methods
private extension SignUpVM {
    func increasePageIndex() {
        let index = pageIndex.value + 1
        pageIndex.accept(index)
        pageIndexIncreaseObserver.onNext(index)
    }
    
    func decreasePageIndex() {
        let index = pageIndex.value - 1
        pageIndex.accept(index)
        pageIndexDecreaseObserver.onNext(index)
    }
}
