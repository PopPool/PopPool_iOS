//
//  TestVC.swift
//  PopPool
//
//  Created by Porori on 7/5/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class TestVC: UIViewController {
    
//    let test = ValidationTextFieldCPNT(type: .social)
//    let test = ValidationTextFieldCPNT(type: .email)
//    let test = BaseTextFieldCPNT()
//    let test = TextFieldCPNT(content: "이런 내용", placeholder: "이런 플레이스 홀더", label: "New description")
//    let test = TextFieldCPNT(type: .email, content: "어떤 내용")
    let test = TextFieldCPNT(type: .social, content: "hmmm")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraint()
    }
    
    private func setConstraint() {
        view.addSubview(test)
//        view.addSubview(testTF2)
//        
        test.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
//        
//        testTF2.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(view.snp.top).inset(100)
//            make.leading.trailing.equalToSuperview()
//        }
    }
}
