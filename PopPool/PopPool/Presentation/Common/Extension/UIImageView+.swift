//
//  UIImageView+.swift
//  PopPool
//

//  Created by Porori on 10/9/24.
//

import UIKit
import RxSwift
import SnapKit

extension UIImageView {
    func setClosedNotice(date: String) {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let cover = CoverView()
        cover.frame = self.bounds
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        self.addSubview(cover)
        
        cover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showLoadingIndicator() {
        stopLoadingIndicator()
        
        let loadingIndicator = LoadingIndicator(frame: self.bounds)
        loadingIndicator.startIndicator()
        
        self.addSubview(loadingIndicator)
    }
    
    /// 적용하여 loadingIndicator를 호출할 수 있습니다.
    func setPresignedImage(from string: [String], service: PreSignedService, bag: DisposeBag) -> Observable<UIImage> {
        self.image = nil
        self.showLoadingIndicator()
        
        return Observable<UIImage>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            service.tryDownload(filePaths: string)
                .subscribe(onSuccess: { [weak self] images in
                    guard let self = self else { return }
                    guard let image = images.first else { return }
                    DispatchQueue.main.async {
                        observer.onNext(image)
                        observer.onCompleted()
                        self.stopLoadingIndicator()
                    }
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.stopLoadingIndicator() // 이미지는 최초에 걸어둔 친구가 있기 때문에 따로 처리하지 않아도 된다.
                        observer.onNext(UIImage(named: "lightLogo")!)
                        observer.onCompleted()
                        print("ImageDownLoad Fail")
                    }
                })
                .disposed(by: bag)
            
            return Disposables.create()
        }
    }
    
    func setClosedNotice(endDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        guard let endDate = dateFormatter.date(from: endDate) else { return }
        let currentDate = Date()
        
        if currentDate <= endDate {
            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let cover = CoverView()
            cover.frame = self.bounds
            cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.addSubview(cover)
            
            cover.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}

//extension UIImageView {
//    func setClosedNotice(endDate: String) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-dd"
//        
//        guard let endDate = dateFormatter.date(from: endDate) else { return }
//        let currentDate = Date()
//        
//        if currentDate <= endDate {
//            self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//            
//            let cover = CoverView()
//            cover.frame = self.bounds
//            cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//            self.addSubview(cover)
//            
//            cover.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
//    }
//}
