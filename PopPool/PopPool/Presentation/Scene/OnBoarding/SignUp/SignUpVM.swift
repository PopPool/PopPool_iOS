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
    
    // MARK: - SignUpRequest
    struct SignUpRequest {
        var userId: String
        var nickName: String
        var gender: String
        var age: Int32
        var socialEmail: String?
        var socialType: String
        var interests: [Int64]
    }
    
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
        var event_step2_availableNickName: PublishSubject<ValidationTextFieldCPNT.ValidationState>
        
        // MARK: - Step 3 Input
        /// Sign Up Step3 primary button  탭 이벤트
        var tap_step3_primaryButton: ControlEvent<Void>
        /// Sign Up Step3 secondary button  탭 이벤트
        var tap_step3_secondaryButton: ControlEvent<Void>
        /// 관심사 변경을 전달하는 Subject
        var event_step3_didChangeInterestList: Observable<[Int64]>
        
        // MARK: - Step 4 Input
        /// step 4 gender segmentedControl 이벤트
        var event_step4_didSelectGender: Observable<String>
        /// step 4 나이 설정 버튼 탭 이벤트
        var tap_step4_ageButton: ControlEvent<Void>
        /// Sign Up Step4 secondary button  탭 이벤트
        var tap_step4_secondaryButton: ControlEvent<Void>
        /// Sign Up Step4 primary button  탭 이벤트
        var tap_step4_primaryButton: ControlEvent<Void>
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
        var step2_fetchUserNickname: BehaviorRelay<String>
        
        // MARK: - Step 3 OutPut
        /// 카테고리 리스트를 가져오는 Subject
        var step3_fetchCategoryList: BehaviorRelay<[String]>
        /// Step 3의 primary button 활성/비활성 상태를 방출하는 Subject
        var step3_primaryButton_isEnabled: PublishSubject<Bool>
        
        // MARK: - Step 4 OutPut
        /// Step 4의 나이선택 모달로 이동
        var step4_moveToAgeSelectVC: PublishSubject<(ClosedRange<Int>, Int)>
        /// 회원가입 완료 VC로 이동
        var step4_moveToSignUpCompleteVC: PublishSubject<(String, [String])> = .init()
    }
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    /// 현재 페이지 인덱스를 관리하는 BehaviorRelay
    private var pageIndex: BehaviorRelay<Int> = .init(value: 0)
    
    /// 현재 페이지 인덱스의 증,감소를 관리하는 PublishSubject
    private let pageIndexIncreaseObserver: PublishSubject<Int> = .init()
    private let pageIndexDecreaseObserver: PublishSubject<Int> = .init()
    
    /// 올바른 유저의 닉네임을 관리하는 subject
    private let userNickName: BehaviorRelay<String> = .init(value: "$유저명$")
    
    /// 나이 Picker 범위
    private let ageRange = (14...100)
    /// 유저 나이
    private var selectAgeIndex: Int = 16
    // 유저 데이터
    var signUpData: SignUpRequest = .init(
        userId: "",
        nickName: "",
        gender: "",
        age: 30,
        socialEmail: "",
        socialType: "",
        interests: []
    )
    
    // MARK: - UseCase
    private let signUpUseCase: SignUpUseCase
    
    // MARK: - init
    init() {
        self.signUpUseCase = AppDIContainer.shared.resolve(type: SignUpUseCase.self)
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
        let fetchCategoryList: BehaviorRelay<[String]> = .init(value: [])
        
        let step4_moveToAgeSelectVC: PublishSubject<(ClosedRange<Int>, Int)> = .init()
        let step4_moveToSignUpCompleteVC: PublishSubject<(String, [String])> = .init()
        
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
                if fetchCategoryList.value.isEmpty {
                    owner.signUpUseCase
                        .fetchCategoryList()
                        .subscribe { list in
                            let listString = list.map { list in
                                list.category
                            }
                            fetchCategoryList.accept(listString)
                            owner.increasePageIndex()
                        } onError: { error in
                            print("fetchIntersetList Error:\(error.localizedDescription)")
                        }
                        .disposed(by: owner.disposeBag)
                } else {
                    owner.increasePageIndex()
                }
            }
            .disposed(by: disposeBag)
        
        //Step2 중복확인 버튼 이벤트 처리
        input.tap_step2_nickNameCheckButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                // 네트워크 사용으로 수정 필요
                let nickName = owner.userNickName.value
                owner.signUpUseCase.checkNickName(nickName: nickName)
                    .subscribe { isDuplicate in
                        step2_isDuplicate.onNext(isDuplicate)
                        if isDuplicate {
                            owner.userNickName.accept("$유저명$")
                        } else {
                            owner.userNickName.accept(nickName)
                        }
                    } onError: { error in
                        print(error)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        //Step2 nickName Validation 상태 이벤트 처리
        input.event_step2_availableNickName
            .withUnretained(self)
            .subscribe(onNext: { (owner, state) in
                switch state {
                case .valid(let nickName):
                    owner.userNickName.accept(nickName)
                    owner.signUpData.nickName = nickName
                    step2_primaryButton_isEnabled.onNext(true)
                default:
                    step2_primaryButton_isEnabled.onNext(false)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - Step 3 transform
        // 관심사 리스트 변경 이벤트 처리
        input.event_step3_didChangeInterestList
            .withUnretained(self)
            .subscribe { (owner, list) in
                owner.signUpData.interests = list
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
            .withUnretained(self)
            .subscribe { (owner, gender) in
                owner.signUpData.gender = gender
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
                let ageRange = owner.ageRange.map{ Int($0) }
                owner.signUpData.age = Int32(ageRange[index])
            }
            .disposed(by: disposeBag)
        
        // Step 4 primary button 탭 이벤트 처리
        input.tap_step4_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.signUpUseCase.trySignUp(
                    userId: owner.signUpData.userId,
                    nickName: owner.signUpData.nickName,
                    gender: owner.signUpData.gender,
                    age: owner.signUpData.age,
                    // TODO: - socialEmail 옵셔널 체이닝 변경 혹은 대응 필요
                    socialEmail: owner.signUpData.socialEmail ?? "",
                    socialType: owner.signUpData.socialType,
                    interests: owner.signUpData.interests
                )
                .subscribe {
                    step4_moveToSignUpCompleteVC
                        .onNext(
                            (
                                owner.signUpData.nickName,
                                owner.signUpData.interests.map{ index in
                                    return fetchCategoryList.value[Int(index)]
                                }
                            )
                        )
                } onError: { error in
                    ToastMSGManager.createToast(message: "SignUpError")
                }
                .disposed(by: owner.disposeBag)

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
            step4_moveToAgeSelectVC: step4_moveToAgeSelectVC,
            step4_moveToSignUpCompleteVC: step4_moveToSignUpCompleteVC
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
