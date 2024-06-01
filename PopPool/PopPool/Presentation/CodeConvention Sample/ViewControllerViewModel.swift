//
//  ViewModel.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import Foundation

import RxSwift
import RxCocoa

final class ViewControllerViewModel: ViewModel {
    
    struct Input {
        var didTapButton: Signal<Void>
    }
    
    struct Output {
        var loadCount: BehaviorRelay<Int>
    }
    
    // MARK: - Properties

    var disposeBag = DisposeBag()
    
    var count: BehaviorRelay<Int> = .init(value: 0)

    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        input.didTapButton.emit { [weak self] _ in
            guard let self = self else { return }
            self.count.accept(self.count.value + 1)
        }
        .disposed(by: disposeBag)
        
        return Output(
            loadCount: self.count
        )
    }
}
