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
        /// Sign Up Step1 primary button  탭 이벤트
        var tap_step1_primaryButton: ControlEvent<Void>
        /// Sign Up Step2 primary button  탭 이벤트
        var tap_step2_primaryButton: ControlEvent<Void>
        /// Sign Up Step3 primary button  탭 이벤트
        var tap_step3_primaryButton: ControlEvent<Void>
        /// 약관 동의 변경을 전달하는 Subject
        var didChangeTerms: PublishSubject<[Bool]>
        /// 관심사 변경을 전달하는 Subject
        var didChangeInterestList: Observable<[String]>
        
    }
    
    /// 출력 이벤트
    struct Output {
        /// 페이지 인덱스 증가 이벤트를 방출하는 Subject
        var increasePageIndex: PublishSubject<Int>
        /// Step 1의 primary button 활성/비활성 상태를 방출하는 Subject
        var step1_primaryButton_isEnabled: PublishSubject<Bool>
        /// 카테고리 리스트를 가져오는 Subject
        var fetchCategoryList: PublishSubject<[String]>
        /// Step 3의 primary button 활성/비활성 상태를 방출하는 Subject
        var step3_primaryButton_isEnabled: PublishSubject<Bool>
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
        let step3_primaryButton_isEnabled: PublishSubject<Bool> = .init()
        let fetchCategoryList: PublishSubject<[String]> = .init()
        
        // 약관 동의 변경 이벤트 처리
        input.didChangeTerms.asObserver()
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
                let credential = MyAuthenticationCredential(
                    accessToken: "eyJhbGciOiJIUzUxMiJ9.eyJpc1RlbXBvcmFyeSI6dHJ1ZSwidXNlcklkIjoiMzU5NzQ0MTczOEBrYWthbyJ9.JC48L0Iw_15tWnfcvkWJueTLTj0uoBNU-ltnkWaDMYXAbhKzu3Ub0b9L1hQGxsXw1-Nv8ywdq5mcA-oyR_knwg",
                    refreshToken: "",
                    accessTokenExpiresIn: 0,
                    refreshTokenExpiresIn: 0
                )
                let repo = SignUpRepositoryImpl()
//                repo.checkNickName(nickName: "하이", credential: credential)
//                    .subscribe(onNext: { response in
//                        print(response)
//                    },onError: { error in
//                        print(error)
//                    })
//                    .disposed(by: owner.disposeBag)
                
                repo.fetchInterestList(credential: credential)
                    .subscribe { list in
                        print(list)
                    } onError: { error in
                        print(error)
                    }
                    .disposed(by: owner.disposeBag)


            }
            .disposed(by: disposeBag)
//        eyJhbGciOiJIUzUxMiJ9.eyJpc1RlbXBvcmFyeSI6dHJ1ZSwidXNlcklkIjoiMzU5NzQ0MTczOEBrYWthbyJ9.JC48L0Iw_15tWnfcvkWJueTLTj0uoBNU-ltnkWaDMYXAbhKzu3Ub0b9L1hQGxsXw1-Nv8ywdq5mcA-oyR_knwg
        // Step 2 primary button 탭 이벤트 처리
        input.tap_step2_primaryButton
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.pageIndex.accept(owner.pageIndex.value + 1)
                increasePageIndex.onNext(owner.pageIndex.value)
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
        
        // 관심사 리스트 변경 이벤트 처리
        input.didChangeInterestList
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
                owner.pageIndex.accept(owner.pageIndex.value + 1)
                increasePageIndex.onNext(owner.pageIndex.value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            increasePageIndex: increasePageIndex,
            step1_primaryButton_isEnabled: step1_primaryButton_isEnabled,
            fetchCategoryList: fetchCategoryList,
            step3_primaryButton_isEnabled: step3_primaryButton_isEnabled
        )
    }
}


