//
//  PreSignedTestViewController.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/5/24.
//

import UIKit

import RxSwift
import RxCocoa

class PreSignedTestViewController: BaseViewController {
    let service = PreSignedService()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        service.upload(request: .init(objectKeyList: ["filePathTest/Test"]))
            .subscribe { response in
                print(response)
            }
            .disposed(by: disposeBag)
    }
}
