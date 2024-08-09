//
//  ListInfoCPNT.swift
//  PopPool
//
//  Created by Porori on 7/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class ListInfoButtonCPNT: UIStackView {
    
    enum ComponentStyle {
        case button(String)
        case icon
        case toggle
    }
    
    // MARK: - Component
    
    private let topSpaceView = UIView()
    private let bottomSpaceView = UIView()
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "person.fill")
        imgView.backgroundColor = .black
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 14)
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 12)
        return label
    }()
    
    private lazy var titleLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(topLabel)
        stack.addArrangedSubview(bottomLabel)
        return stack
    }()
    
    private lazy var profileViewStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(profileImageView)
        stack.addArrangedSubview(titleLabelStack)
        stack.spacing = 12
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(infoTitle: String, subTitle: String, style: ComponentStyle) {
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
        self.addArrangedSubview(profileViewStack)
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
    
    func update(title: String, subTitle: String) {
        let isDateChecked = checkIfDate(input: subTitle)
        topLabel.text = title
        bottomLabel.text = isDateChecked
        bottomLabel.textColor = .g400
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
    
    private func setStyle(title: String, subTitle: String, style: ComponentStyle) {
        let isDateChecked = checkIfDate(input: subTitle)
        topLabel.text = title
        bottomLabel.text = isDateChecked
        bottomLabel.textColor = .g400
        
        switch style {
        case .button(let buttonName):
            actionButton.setTitle(buttonName, for: .normal)
            actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            
            actionButton.backgroundColor = .red
            actionButton.titleLabel?.font = .EngFont(style: .regular, size: 13)
            actionButton.layer.cornerRadius = 4
            actionButton.clipsToBounds = true
            
        case .icon:
            actionButton.setImage(UIImage(named: "line_signUp"), for: .normal)
            actionButton.contentMode = .scaleAspectFit
            actionButton.contentEdgeInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: 9.5, right: 0)
            
            actionButton.snp.makeConstraints { make in
                make.width.equalTo(22)
            }
            
        case .toggle:
            let toggle = UISwitch()
            toggle.onTintColor = .blu400
            profileViewStack.addArrangedSubview(toggle)
            actionButton.isHidden = true
        }
        
        profileViewStack.setCustomSpacing(42, after: titleLabelStack)
        profileViewStack.addArrangedSubview(actionButton)
    }
}
