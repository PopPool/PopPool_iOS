//
//  AppleLoginTestVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

import AuthenticationServices

class AppleLoginTestVC: UIViewController {
    let disposeBag = DisposeBag()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button
    }()
    
    private let authUseCase: AuthUseCase
    
    init() {
        self.authUseCase = AppDIContainer.shared.resolve(type: AuthUseCase.self)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        
        button.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.appleLogin()
            }.disposed(by: disposeBag)
    }
    
    
    func tryLogin() {
        
    }
}
