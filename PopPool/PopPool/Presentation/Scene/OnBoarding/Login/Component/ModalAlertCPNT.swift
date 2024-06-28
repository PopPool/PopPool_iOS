//
//  ModalAlertCPNT.swift
//  PopPool
//
//  Created by Porori on 6/28/24.
//

import Foundation
import UIKit

class ModalAlertCPNT: UIViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("모달 테스트", for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(tapToModal), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 150),
            button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1)
        ])
    }
    
    @objc func tapToModal() {
        print("버튼 탭 완료")
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            
            let modalVC = ModalAlertCPNT()
            self.present(modalVC, animated: true)
        }
    }
}
