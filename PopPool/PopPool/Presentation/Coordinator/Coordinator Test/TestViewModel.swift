//
//  TestViewModel.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation

import RxSwift
import RxCocoa
import KakaoSDKUser

protocol TestVCDelegate {
    func popViewController()
}

final class TestViewModel: ViewModel {
    
    struct Input {
        var didTapButton: Signal<Void>
        var popButton: Signal<Void>
    }
    
    struct Output {
        var loadCount: BehaviorRelay<Int>
    }
    
    var provider = ProviderImpl()
    
    // MARK: - Properties

    var disposeBag = DisposeBag()
    
    var count: BehaviorRelay<Int> = .init(value: 0)
    
    var delegate: TestVCDelegate?

    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        input.didTapButton.emit { [weak self] _ in
            guard let self = self else { return }
            self.count.accept(self.count.value + 1)
            testProvider()
        }
        .disposed(by: disposeBag)
        
        input.popButton.emit { [weak self] _ in
            guard let self = self else { return }
            print("돌아가기 버튼이 눌렸습니다.")
            self.delegate?.popViewController()
        }
        .disposed(by: disposeBag)
        
        return Output(
            loadCount: self.count
        )
    }
    
    func handlePop() {
        delegate?.popViewController()
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
}
