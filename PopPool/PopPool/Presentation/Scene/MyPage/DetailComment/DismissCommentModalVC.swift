//
//  DismissCommentModalVC.swift
//  PopPool
//
//  Created by Porori on 9/9/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol DismissCommentDelegate: AnyObject {
    func dismissViewController()
}

final class DismissCommentModalVC: ModalViewController {
    
    private let header = ContentTitleCPNT(
        title: "코멘트 작성을 그만하시겠어요?",
        type: .title_sub_bs(
            subTitle: "화면을 나가실 경우 작성중인 내용은 저장되지 않아요.",
            buttonImage: nil))
    
    
    private let cancelButton = ButtonCPNT(
        type: .secondary, title: "계속하기")
    private let stopButton = ButtonCPNT(
        type: .primary, title: "그만하기")
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(stopButton)
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(buttonStack)
        stack.axis = .vertical
        stack.spacing = CGFloat(Constants.spaceGuide.medium200)
        return stack
    }()
    
    private let disposeBag = DisposeBag()
    weak var delegate: DismissCommentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        cancelButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                // 중간 도중 복귀
                print("진행 버튼 눌림")
                owner.dismissBottomSheet()
            }).disposed(by: disposeBag)
        
        stopButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                // 중간 도중 이탈
                owner.dismissBottomSheet()
                owner.delegate?.dismissViewController()
            }).disposed(by: disposeBag)
    }
    
    private func setUp() {
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let text = "화면을 나가실 경우 작성중인 내용은 저장되지 않아요."
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.4
        let attribute = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        
        header.subTitleLabel.attributedText = attribute
        header.subTitleLabel.font = .KorFont(style: .regular, size: 14)
    }
    
    private func setUpConstraint() {
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        setContent(content: stackView)
    }
}
