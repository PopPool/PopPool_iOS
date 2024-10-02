//
//  UIImageView+.swift
//  PopPool
//
//  Created by Porori on 10/1/24.
//

import UIKit
import SnapKit

extension UIImageView {
    func stopLoadingIndicator() {
        self.subviews.forEach { subview in
            if let loadingIndicator = subview as? LoadingIndicator {
                loadingIndicator.stopIndicator()
            }
        }
    }
    
    func showLoadingIndicator() {
        if self.image == nil {
            stopLoadingIndicator()
            let loadingIndicator = LoadingIndicator(frame: self.bounds)
            self.addSubview(loadingIndicator)
            
            loadingIndicator.startIndicator()
        }
    }
}
