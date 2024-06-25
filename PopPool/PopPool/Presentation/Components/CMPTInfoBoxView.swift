//
//  CMPTInfoBox.swift
//  PopPool
//
//  Created by Porori on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

class CMPTInfoBoxView: UIView {
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .g600
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .brandAppleLight
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 15)
        label.numberOfLines = 0
        label.text = "이렇게 된다"
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CMPTInfoBoxView {
    
    func updateLabel(info: String) {
        calculateInfoLength()
    }
    
    private func calculateInfoLength() {
        
    }
    
    private func setLayout() {
        addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(infoLabel)
        
        bgView.snp.makeConstraints { make in
            make.width.equalTo(295)
            make.height.equalTo(53)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
    }
}
