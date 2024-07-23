//
//  ListInfoButton.swift
//  PopPool
//
//  Created by Porori on 7/23/24.
//

import UIKit
import SnapKit

final class ListInfoButton: UIStackView {
    
    enum ButtonStyle {
        case button(String)
        case icon
        case toggle
    }
    
    // MARK: - Component
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    
    private let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.fill")
        imgView.backgroundColor = .black
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        return label
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subLabel)
        return stack
    }()
    
    lazy var profileStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(profileImageView)
        stack.addArrangedSubview(titleStack)
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    // MARK: - Initializer
    
    init(infoTitle: String, subTitle: String, style: ButtonStyle) {
        super.init(frame: .zero)
        setUp()
        setUpConstraints()
        setStyle(title: infoTitle, subTitle: subTitle, style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
    }
    
    // MARK: - Methods
    
    private func setUp() {
        self.axis = .vertical
    }
    
    private func setUpConstraints() {
        self.addArrangedSubview(topSpaceView)
        self.addArrangedSubview(profileStack)
        self.addArrangedSubview(bottomSpaceView)
        
        topSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.spaceGuide.medium200)
        }
    }
    
    /// Date 타입으로 변환 가능 여부를 파악하여 날짜 혹은 String을 반환합니다
    /// - Parameter input: userId 혹은 날짜를 받습니다
    /// - Returns: String 타입을 반환합니다
    private func checkIfDate(input: String) -> String {
        
        // 서버에서 받는 Date 형식에 따라 ISODateFormatter 활용 여부 변경 예정
        let isoDateFomatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = isoDateFomatter.date(from: input) {
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return input
        }
    }
    
    private func setStyle(title: String, subTitle: String, style: ButtonStyle) {
        let isDate = checkIfDate(input: subTitle)
        titleLabel.text = title
        subLabel.text = isDate
        subLabel.textColor = .g400
        
        switch style {
        case .button(let buttonName):            
            let button = UIButton()
            button.setTitle(buttonName, for: .normal)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            
            button.titleLabel?.font = .EngFont(style: .regular, size: 13)
            button.backgroundColor = .red
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
            
            profileStack.setCustomSpacing(42, after: titleStack)
            profileStack.addArrangedSubview(button)
            
        case .icon:
            let button = UIButton()
            button.setImage(UIImage(named: "line_signUp"), for: .normal)
            button.contentMode = .scaleAspectFit
            button.contentEdgeInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: 9.5, right: 0)
            
            button.snp.makeConstraints { make in
                make.width.equalTo(22)
            }
            
            profileStack.setCustomSpacing(42, after: titleStack)
            profileStack.addArrangedSubview(button)
            
        case .toggle:            
            let toggle = UISwitch()
            toggle.onTintColor = .blu400
            profileStack.addArrangedSubview(toggle)
        }
    }
}
