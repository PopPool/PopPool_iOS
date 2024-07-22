//
//  CMPTInfoBox.swift
//  PopPool
//
//  Created by Porori on 6/25/24.
//

import Foundation
import UIKit
import SnapKit

enum Info {
    case email(String)
    case list([String])
}

final class InfoBoxViewCPNT: UIView {
    
    // MARK: - Properties
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .g50
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .infoLogoApple
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .EngFont(style: .regular, size: 15)
        label.numberOfLines = 0
        label.textColor = .g600
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    init(content: Info) {
        super.init(frame: .zero)
        setContentConstraint(content: content)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoBoxViewCPNT {
    
    // MARK: - Methods
    
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
    
    /// 콘텐츠에 따라 제약을 다르게 잡습니다
    /// - Parameter content: Content 타입을 받습니다 (email, list)
    private func setContentConstraint(content: Info) {
        
        switch content {
        case .email(let email):
            setLayoutForEmail()
            
            guard checkIfCorrectFormat(email: email) else { return }
            let displayableEmail = hideInfo(email)
            self.infoLabel.text = displayableEmail
            
        case .list(let list):
            setLayoutForList()
            setListData(content: list)
        }
    }
    
    /// 단일 이메일 데이터를 위한 제약입니다
    private func setLayoutForEmail() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview()
            make.height.equalTo(53)
        }
        
        bgView.addSubview(logoImageView)
        bgView.addSubview(infoLabel)
        
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
    
    /// 배열 타입 데이터를 위한 제약입니다
    private func setLayoutForList() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.top.equalToSuperview()
        }
        
        bgView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    /// 배열 데이터에 bulletpoint가 더해져 보이도록 처리하는 메서드
    /// - Parameter content: String 타입의 배열 데이터를 받습니다
    private func setListData(content: [String]) {
        for content in content {
            let bulletPoint = "\u{2022}"
            var bulletText = bulletPoint + content
            bulletText.insert(" ", at: bulletText.index(after: bulletPoint.startIndex))
            
            let listLabel = UILabel()
            let style = NSMutableParagraphStyle()
            style.firstLineHeadIndent = 0
            style.headIndent = 8
            let attributedString = NSMutableAttributedString(string: bulletText,
                                                             attributes: [
                                                                .paragraphStyle: style
                                                             ])
            listLabel.font = .EngFont(style: .regular, size: 15)
            listLabel.numberOfLines = 0
            listLabel.textColor = .g600
            
            listLabel.attributedText = attributedString
            stackView.addArrangedSubview(listLabel)
        }
    }
}
