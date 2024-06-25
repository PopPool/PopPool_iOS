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
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .g50
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .infoLogoApple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 15)
        label.numberOfLines = 0
        label.textColor = .g600
        label.text = "abcdefg@gmail.com"
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    func updateLabel(email: String) {
        guard checkIfCorrectFormat(email: email) else { return }
        let displayableEmail = hideInfo(email)
        
        DispatchQueue.main.async {
            self.infoLabel.text = displayableEmail
        }
    }
    
    private func hideInfo(_ sensitiveInfo: String) -> String {
        let length = sensitiveInfo.count
        if length <= 6 { return sensitiveInfo }
        return String(sensitiveInfo.prefix(3) + String(repeating: "*", count: length - 4) + sensitiveInfo.suffix(4))
    }
    
    private func checkIfCorrectFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: email)
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
            make.leading.equalToSuperview().inset(41)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(22)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(4)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
    }
}
