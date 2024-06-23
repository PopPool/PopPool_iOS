//
//  VCSignUp.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/23/24.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class VCSignUp: UIViewController {
    
    private let progressIndicator: CMPTProgressIndicator = CMPTProgressIndicator(totalStep: 4, startPoint: 1)
    private let bottomButton: CMPTButton = CMPTButton(type: .kakao, contents: "카카오톡으로 로그인")
    private let midleButton: CMPTButton = CMPTButton(type: .apple, contents: "Apple로 로그인")
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(progressIndicator)
        view.addSubview(midleButton)
        view.addSubview(bottomButton)
        
        progressIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(SpaceGuide._16px)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        midleButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.center.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(SpaceGuide._48px)
        }
        
        bottomButton.rx.tap.subscribe { _ in
            self.progressIndicator.increaseIndicator()
        }
        .disposed(by: disposeBag)
        
        midleButton.rx.tap.subscribe { _ in
            self.progressIndicator.decreaseIndicator()
        }
        .disposed(by: disposeBag)
    }
}
