//
//  commentTypeVC.swift
//  PopPool
//
//  Created by Porori on 8/31/24.
//

import UIKit
import RxSwift
import SnapKit

final class CommentTypeVC: ModalViewController {
    
    let header = ContentTitleCPNT(
        title: "코멘트 작성 방법 선택",
        type: .title_bs(buttonImage: UIImage(named: "xmark_signUp")))
        
    let normalComment = ListRowCPNT(
        title: "일반 코멘트 작성하기",
        image: nil)
    
    let socialComment = ListRowCPNT(
        title: "인스타그램 연동 코멘트 작성하기",
        image: nil)
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let topSpacer = UIView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }
    
    private func bind() {
        header.button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismissBottomSheet()
            })
            .disposed(by: disposeBag)
        
        // 일반 코멘트 작성
        normalComment.tappedObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                print("일반이 눌렸습니다.")
                owner.dismissBottomSheet()
                let vc = NormalCommentVC(viewModel: NormalCommentVM())
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 인스타그램 코멘트 작성
        socialComment.tappedObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismissBottomSheet()
                let vc = SocialCommentVC(viewModel: SocialCommentVM())
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUp() {
        socialComment.lineView.isHidden = true
        header.isLayoutMarginsRelativeArrangement = true
        header.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        normalComment.iconView.isHidden = true
        socialComment.iconView.isHidden = true
    }
    
    private func setUpConstraint() {
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(topSpacer)
        stack.addArrangedSubview(normalComment)
        stack.addArrangedSubview(socialComment)
        
        topSpacer.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide.small300)
        }
        setContent(content: stack)
    }
}
