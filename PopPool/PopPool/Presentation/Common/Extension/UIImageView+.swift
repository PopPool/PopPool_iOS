//
//  UIImageView+.swift
//  PopPool
//
//  Created by Porori on 10/1/24.
//

import UIKit
import SnapKit
import RxSwift

extension UIImageView {
    func stopLoadingIndicator() {
        self.subviews.forEach { subview in
            if let loadingIndicator = subview as? LoadingIndicator {
                loadingIndicator.stopIndicator()
            }
        }
    }
    
    func showLoadingIndicator() {
        stopLoadingIndicator()
        
        let loadingIndicator = LoadingIndicator(frame: self.bounds)
        loadingIndicator.startIndicator()
        
        self.addSubview(loadingIndicator)
    }
    
    func setPresignedImage(from string: [String], service: PreSignedService, bag: DisposeBag) {
        self.image = UIImage(systemName: "lasso")
        self.showLoadingIndicator()
        print("이미지 처리 준비!!")
        
        service.tryDownload(filePaths: string)
            .subscribe(onSuccess: { [weak self] images in
                print("이미지 처리 중!!")
                guard let self = self else { return }
                guard let image = images.first else { return }
                DispatchQueue.main.async {
                    self.image = image
                    self.stopLoadingIndicator()
                }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                print("이미지 처리가 안됐다!!!")
                DispatchQueue.main.async {
                    self.stopLoadingIndicator() // 이미지는 최초에 걸어둔 친구가 있기 때문에 따로 처리하지 않아도 된다.
                }
            })
            .disposed(by: bag)
    }
}
