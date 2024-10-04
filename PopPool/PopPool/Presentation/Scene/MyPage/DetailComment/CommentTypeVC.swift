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

    let popUpStoreName: String
    let popUpId: Int64
    let topSpacer = UIView()
    var onCommentAdded: (() -> Void)?
    private let disposeBag = DisposeBag()

    init(popUpStoreName: String, popUpId: Int64) {
        self.popUpStoreName = popUpStoreName
        self.popUpId = popUpId
        print("코멘트 타입 화면 생성: 팝업 스토어 = \(popUpStoreName), 팝업 ID = \(popUpId)")

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpConstraint()
        bind()
    }

    private func bind() {
        //        normalComment.tappedObserver
        //            .withUnretained(self)
        //            .subscribe(onNext: { (owner, _) in
        //                owner.dismissBottomSheet()
        //                owner.pushNormalCommentVC()
        //            })
        //            .disposed(by: disposeBag)


        header.button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismissBottomSheet()
            })
            .disposed(by: disposeBag)

        // commentTypeVC.swift

        normalComment.tappedObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                // 모달을 먼저 닫고
                let vm = NormalCommentVM(popUpName: owner.popUpStoreName, popUpStoreId: owner.popUpId)
                let vc = NormalCommentVC(viewModel: vm)
                vc.onCommentAdded = {
                    owner.dismissBottomSheet()
                    if let detailVC = owner.navigationController?.viewControllers.first(where: { $0 is PopupDetailViewController }) {
                        owner.navigationController?.popToViewController(detailVC, animated: true)
                    }
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        socialComment.tappedObserver
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let vm = SocialCommentVM(clipboardManager: ClipboardManager.shared)
                let vc = SocialCommentVC(viewModel: vm)
                vc.onCommentAdded = {
                    owner.dismissBottomSheet()
                    if let detailVC = owner.navigationController?.viewControllers.first(where: { $0 is PopupDetailViewController }) {
                        owner.navigationController?.popToViewController(detailVC, animated: true)
                    }
                }
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
    private func pushNormalCommentVC() {
        let vm = NormalCommentVM(popUpName: popUpStoreName, popUpStoreId: popUpId)
        let vc = NormalCommentVC(viewModel: vm)
        vc.onCommentAdded = { [weak self] in
            self?.onCommentAdded?()
            self?.navigationController?.popToViewController(self!, animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    private func pushSocialCommentVC() {
        let vm = SocialCommentVM(clipboardManager: ClipboardManager.shared)
        let vc = SocialCommentVC(viewModel: vm)
        vc.onCommentAdded = { [weak self] in
            self?.onCommentAdded?()
            self?.navigationController?.popToViewController(self!, animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
