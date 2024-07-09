//
//  ProfileImageViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit

final class ProfileImageViewCPNT: UIImageView {
    enum ProfileSize: CGFloat {
        case large = 96
        case midium = 64
        case small = 36
    }
    
    init(size: ProfileSize) {
        super.init(frame: .zero)
        setUp(size: size)
        setUpConstraints(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileImageViewCPNT {
    func setUp(size: ProfileSize) {
//        image = UIImage(named: "Profile_Logo")
//        image = UIImage(named: "TestImage")
        contentMode = .scaleAspectFill
        backgroundColor = .g100
        layer.cornerRadius = size.rawValue / 2
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.g200.cgColor
    }
    
    func setUpConstraints(size: ProfileSize) {
        self.snp.makeConstraints { make in
            make.size.equalTo(size.rawValue)
        }
    }
}
