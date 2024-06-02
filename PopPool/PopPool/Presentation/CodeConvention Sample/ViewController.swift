//
//  ViewController.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class ViewController: UIViewController { // 상속 필요 없을시 Final 키워드 붙이기
    // MARK: - Properties
    
    var viewModel: ViewControllerViewModel
    
    var disposeBag = DisposeBag()
    
    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    // MARK: - init

    init(viewModel: ViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupConstraints()
        setupBind()
    }
}

// MARK: - Methods
extension ViewController {
    
    /// SomeFunc
    /// - Parameter some: 어쩌구 저쩌구
    /// - Returns: 어쩌구 리턴 값
    func someFunc(some: Int) -> Int {
        return 1
    }
}

// MARK: - Setup
extension ViewController {
    
    func setupConstraints() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    func setupBind() {
        
        let input = ViewControllerViewModel.Input(
            didTapButton: button.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.loadCount
            .withUnretained(self)
            .subscribe { owner, count in
                owner.button.setTitle("\(count) Tap", for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    func setupSome() {
        
    }
}
