//
//  ListContentCPNT.swift
//  PopPool
//
//  Created by Porori on 8/7/24.
//

import UIKit
import SnapKit

final class ListContentCPNT: UIStackView {
    
    //MARK: - Components
    
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4
        return stack
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 6
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .bold, size: 13)
        label.textColor = .g1000
        return label
    }()
    
    let titleActionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bottomArrow_signUp"), for: .normal)
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 13)
        label.textColor = .g600
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .KorFont(style: .regular, size: 11)
        label.textColor = .g400
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_signUp"), for: .normal)
        button.contentMode = .center
        return button
    }()
    
    private let titleHorizontalSpaceView = UIView()
    private let firstBottomSpaceView = UIView()
    private let secondBottomSpaceView = UIView()
    
    //MARK: - Initializer
    
    init(title: String, subTitle: String, info: String) {
        super.init(frame: .zero)
        setUp(title: title, subTitle: subTitle, info: info)
        setUpConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    //MARK: - Methods
    
    public func setUp(title: String, subTitle: String, info: String) {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .vertical
        containerStackView.alignment = .center
        
        titleLabel.text = title
        contentLabel.text = subTitle
        dateLabel.text = info
    }
    
    private func setUpConstraint() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleActionButton)
        titleStackView.addArrangedSubview(titleHorizontalSpaceView)
        
        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(contentLabel)
        contentStackView.addArrangedSubview(dateLabel)
        
        containerStackView.addArrangedSubview(contentStackView)
        containerStackView.addArrangedSubview(actionButton)
        
        self.addArrangedSubview(containerStackView)
        self.addArrangedSubview(firstBottomSpaceView)
        self.addArrangedSubview(secondBottomSpaceView)
        
        titleActionButton.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        
        actionButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        firstBottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
        
        secondBottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small100)
        }
    }
}
