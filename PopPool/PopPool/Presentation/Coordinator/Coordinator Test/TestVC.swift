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

class TestVC: UIViewController {
    // MARK: - Properties
    
    var viewModel: TestViewModel
    var provider = ProviderImpl()
    var disposeBag = DisposeBag()
    
    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("present", for: .normal)
        return button
    }()

    var popButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("pop", for: .normal)
        return button
    }()
    
    // MARK: - init

    init(viewModel: TestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - LifeCycle
extension TestVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
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
        
        let input = TestViewModel.Input(
            presentButtonTapped: button.rx.tap.asSignal(),
            popButtonTapped: popButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
    }
}
