//
//  TestVC.swift
//  PopPool
//
//  Created by Porori on 6/10/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

protocol TestVCDelegate {
    func popViewController()
}

/// Coordinator를 테스트하기 위한 테스트용 VC입니다
class TestVC: UIViewController {
    // MARK: - Properties
    
    var viewModel: ViewControllerViewModel
    var provider = ProviderImpl()
    var disposeBag = DisposeBag()
    var delegate: TestVCDelegate?
    
    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    var popButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        return button
    }()
    
    // MARK: - init

    init(viewModel: ViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension TestVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupConstraints()
        setupBind()
    }
}

// MARK: - Methods
extension TestVC {
    
    /// SomeFunc
    /// - Parameter some: 어쩌구 저쩌구
    /// - Returns: 어쩌구 리턴 값
    func someFunc(some: Int) -> Int {
        return 1
    }
}

// MARK: - Setup
extension TestVC {
    
    func setupConstraints() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        
        view.addSubview(popButton)
        popButton.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(50)
        }
    }
    
    func setupBind() {
        
        popButton.rx.tap.bind { _ in
            print("돌아가기 버튼이 눌렸습니다.")
            self.delegate?.popViewController()
        }
        .disposed(by: disposeBag)
        
        
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
}
