//
//  VCSignUp.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/23/24.
//

import Foundation
import UIKit
import SnapKit

final class VCSignUp: UIViewController {
    
    private let progressIndicator: CMPTProgressIndicator = CMPTProgressIndicator(totalStep: 4, startStep: 1)
    private let bottomButton: CMPTButton = CMPTButton(type: .primary, contents: "확인")
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(progressIndicator)
        view.addSubview(bottomButton)
        
        progressIndicator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(SpaceGuide._16px)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(4)
        }
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(SpaceGuide._48px)
        }
    }
}
