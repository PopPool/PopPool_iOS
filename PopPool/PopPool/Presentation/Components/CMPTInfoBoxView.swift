//
//  CMPTInfoBox.swift
//  PopPool
//
//  Created by Porori on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

final class CMPTInfoBoxView: UIView {
    
    // MARK: - Properties
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CMPTInfoBoxView {
    
    // MARK: - Methods
    
    /// 인포박스에 이메일을 바꾸면서 일부를 가리는 메서드
    /// - Parameter email: 가리고자 하는 이메일을 받습니다
    func updateLabel(email: String) {
        
        // 이메일 형식인지 먼저 확인
        guard checkIfCorrectFormat(email: email) else { return }
        
        // 맞을 경우, 가려진 형식으로 변환
        let displayableEmail = hideInfo(email)
        
        // 변환된 값을 infoLabel에 업데이트
        DispatchQueue.main.async {
            self.infoLabel.text = displayableEmail
        }
    }
    
    /// 이메일 일부를 가리는 메서드
    /// - Parameter sensitiveInfo: 가리고자 하는 이메일을 받습니다
    /// - Returns: 이메일 일부가 '*'로 가려집니다
    private func hideInfo(_ sensitiveInfo: String) -> String {
        let length = sensitiveInfo.count
        if length <= 6 { return sensitiveInfo }
        
        // 이메일 중, '@' 앞에 있는 데이터만 숨김 처리를 합니다
        if let index = sensitiveInfo.firstIndex(of: "@") {
            let emailData = sensitiveInfo.prefix(upTo: index)
            return String(
                sensitiveInfo.prefix(3)
                + String(repeating: "*", count: emailData.count)
                + sensitiveInfo.suffix(from: index)
            )
        }
        return ""
    }
    
    /// 이메일 형식을 확인하는 메서드
    /// - Parameter email: 확인하고자 하는 이메일을 받습니다
    /// - Returns: 이메일이 맞는지 아닌지를 반환합니다
    private func checkIfCorrectFormat(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    private func setUpConstraint() {
        addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(infoLabel)
        
        // updated constraint to have top and bottom
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview()
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
