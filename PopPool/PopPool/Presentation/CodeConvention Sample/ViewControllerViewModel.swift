//
//  ViewModel.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import Foundation

import RxSwift
import RxCocoa
import KakaoSDKUser

protocol HomeViewControllerDelegate {
    func pushToNextViewController()
}

final class ViewControllerViewModel: ViewModel {
    
    struct Input {
        var didTapButton: Signal<Void>
        var pushToNextScreen: Signal<Void>
    }
    
    struct Output {
        var loadCount: BehaviorRelay<Int>
    }
    
    var provider = ProviderImpl()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    var count: BehaviorRelay<Int> = .init(value: 0)
    
    var delegate: HomeViewControllerDelegate?
    
    var fetchUserCredentialUseCase: FetchUserCredentialUseCase
    
    var authUseCase: AuthUseCase
    
    init() {
        self.fetchUserCredentialUseCase = AppDIContainer.shared.resolve(
            type: FetchUserCredentialUseCase.self,
            identifier: SocialType.apple.rawValue
        )
        
        self.authUseCase = AppDIContainer.shared.resolve(
            type: AuthUseCase.self
        )
    }
    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        input.didTapButton.emit { [weak self] _ in
            guard let self = self else { return }
            self.count.accept(self.count.value + 1)
            testLogin()
        }
        .disposed(by: disposeBag)
        
        input.pushToNextScreen.emit { [weak self] _ in
            self?.handleTestTap()
        }
        .disposed(by: disposeBag)
        
        return Output(
            loadCount: self.count
        )
    }
    
    func handleTestTap() {
        print("버튼이 눌렸습니다.")
        delegate?.pushToNextViewController()
    }
    
    func testLogin() {
        fetchUserCredentialUseCase.execute()
            .withUnretained(self)
            .subscribe { (owner, userCredential) in
                owner.authUseCase
                    .tryLogIn(userCredential: userCredential, socialType: SocialType.apple.rawValue)
                    .subscribe { loginResponse in
                        print(loginResponse)
                    } onError: { error in
                        print(error)
                    }
                    .disposed(by: owner.disposeBag)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
}
