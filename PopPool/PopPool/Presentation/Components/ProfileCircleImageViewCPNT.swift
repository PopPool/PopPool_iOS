//
//  ProfileCircleImageViewCPNT.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/8/24.
//

import UIKit
import SnapKit

final class ProfileCircleImageViewCPNT: UIImageView {
    enum ProfileSize: CGFloat {
        case large = 96
        case midium = 64
        case small = 36
    }
    
    // MARK: - init
    init(size: ProfileSize) {
        super.init(frame: .zero)
        setUp(size: size)
        setUpConstraints(size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ProfileCircleImageViewCPNT {
    func setUp(size: ProfileSize) {
        // TODO: - 수정 필요
        contentMode = .scaleAspectFill
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
