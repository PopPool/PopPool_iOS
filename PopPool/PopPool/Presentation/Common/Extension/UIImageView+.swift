//
//  UIImageView+.swift
//  PopPool
//

//  Created by Porori on 10/9/24.
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
    
    /// 적용하여 loadingIndicator를 호출할 수 있습니다.
    func setPresignedImage(from string: [String], service: PreSignedService, bag: DisposeBag) {
        self.image = nil
        self.showLoadingIndicator()
        
        service.tryDownload(filePaths: string)
            .subscribe(onSuccess: { [weak self] images in
                guard let self = self else { return }
                guard let image = images.first else { return }
                DispatchQueue.main.async {
                    self.image = image
                    self.stopLoadingIndicator()
                }
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.stopLoadingIndicator() // 이미지는 최초에 걸어둔 친구가 있기 때문에 따로 처리하지 않아도 된다.
                }
            })
            .disposed(by: bag)

extension UIImageView {
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
