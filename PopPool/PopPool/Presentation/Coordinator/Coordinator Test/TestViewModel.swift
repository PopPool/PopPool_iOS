//
//  TestViewModel.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol TestVCDelegate {
    func popViewController()
    func presentViewController()
}

final class TestViewModel: ViewModel {

    struct Input {
        var presentButtonTapped: Signal<Void>
        var popButtonTapped: Signal<Void>
    }

    struct Output {

    }

    // MARK: - Properties

    var disposeBag = DisposeBag()
    var delegate: TestVCDelegate?

    // MARK: - Methods

    func transform(input: Input) -> Output {

        input.presentButtonTapped.emit { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.presentViewController()
        }
        .disposed(by: disposeBag)

        input.popButtonTapped.emit { [weak self] _ in
            guard let self = self else { return }
            print("돌아가기 버튼이 눌렸습니다.")
            self.delegate?.popViewController()
        }
        .disposed(by: disposeBag)

        return Output(

        )
    }
}
