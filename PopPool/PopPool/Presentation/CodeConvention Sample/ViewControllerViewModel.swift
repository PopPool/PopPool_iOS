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

final class ViewControllerViewModel: ViewModel {
    
    struct Input {
        var didTapButton: Signal<Void>
    }
    
    struct Output {
        var loadCount: BehaviorRelay<Int>
    }
    
    var provider = ProviderImpl()
    
    var kakaoService = KakaoAuthServiceImpl()
    
    // MARK: - Properties

    var disposeBag = DisposeBag()
    
    var count: BehaviorRelay<Int> = .init(value: 0)

    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        input.didTapButton.emit { [weak self] _ in
            guard let self = self else { return }
            self.count.accept(self.count.value + 1)
            testProvider()
            testLogin()
        }
        .disposed(by: disposeBag)
        
        return Output(
            loadCount: self.count
        )
    }
    
    func testProvider() {
        let requestDTO = TestRequestDTO(query: "cat")
        let endpoint = APIEndpoint.fetchData(with: requestDTO)
        
        provider.requestData(with: endpoint)
            .subscribe { data in
                print(data)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

    }
    
    func testLogin() {
        kakaoService.tryFetchToken()
            .subscribe { token in
                print(token)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)

    }
}
