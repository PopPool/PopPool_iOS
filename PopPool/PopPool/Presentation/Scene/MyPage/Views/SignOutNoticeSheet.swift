//
//  SignOutNoticeSheet.swift
//  PopPool
//
//  Created by Porori on 7/17/24.
//

import UIKit
import SnapKit
import RxSwift

class SignOutNoticeSheet: ModalViewController {
    
    private let titleHeader: ContentTitleCPNT
    private let confirmButton: ButtonCPNT
    private let skipButton: ButtonCPNT
    private let noticeLabel: InfoBoxViewCPNT
    private let headerSpaceView = UIView()
    private let bottomSpaceView = UIView()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.spacing = 12
        stack.addArrangedSubview(skipButton)
        stack.addArrangedSubview(confirmButton)
        return stack
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    init(userNickname: String, content: [String]) {
        self.titleHeader = ContentTitleCPNT(title: "\(userNickname)님, 팝풀 서비스를\n정말 탈퇴하시겠어요?", type: .title_bs(buttonImage: nil))
        self.confirmButton = ButtonCPNT(type: .primary, title: "동의 후 탈퇴하기")
        self.skipButton = ButtonCPNT(type: .secondary, title: "취소")
        self.noticeLabel = InfoBoxViewCPNT(content: .list(content))
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        stackView.addArrangedSubview(titleHeader)
        stackView.addArrangedSubview(headerSpaceView)
        stackView.addArrangedSubview(noticeLabel)
        stackView.addArrangedSubview(bottomSpaceView)
        stackView.addArrangedSubview(buttonStack)
        
        headerSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        
        bottomSpaceView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.medium200)
        }
        
        skipButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(108)
        }
                
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        setContent(content: stackView)
    }
}
