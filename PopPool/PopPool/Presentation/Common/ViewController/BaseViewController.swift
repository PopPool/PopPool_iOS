//
//  BaseViewController.swift
//  PopPool
//
//  Created by Porori on 7/4/24.
//

import UIKit

/// UIViewController의 Base 역할
class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("🍎", self, #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    
    deinit {
        print("🍏", self, #function)
    }
}
