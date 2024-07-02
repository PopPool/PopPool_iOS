//
//  TermsVC.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TermsVC: ModalViewController {
    private var headerView: HeaderViewCPNT
    
    private let textView: UITextView = {
        let view = UITextView()
        view.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        view.font = .KorFont(style: .regular, size: 15)
        return view
    }()
    
    private let spacingView = UIView()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    init(title: String, content: String) {
        self.headerView = HeaderViewCPNT(title: title, style: .icon(UIImage(named: "xmark_signUp")))
        self.headerView.leftBarButton.isHidden = true
        self.headerView.titleLabel.font = .KorFont(style: .bold, size: 15)
        textView.text = content

        super.init()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        bind()
    }
    
    func setUpConstraints() {
        let size = CGSize(width: view.frame.width - (20 * 2), height: .infinity)
        let textViewHeight = textView.sizeThatFits(size).height
        
        view.addSubview(stackView)
        textView.snp.makeConstraints { make in
            make.height.equalTo(textViewHeight < (UIScreen.main.bounds.height * 0.8) ? textViewHeight : UIScreen.main.bounds.height * 0.8)
        }
        spacingView.snp.makeConstraints { make in
            make.height.equalTo(Constants.spaceGuide._32px)
        }
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(spacingView)
        stackView.addArrangedSubview(textView)
        self.setContent(content: stackView)
    }
    
    func bind() {
        headerView.rightBarButton.rx.tap
            .withUnretained(self)
            .subscribe { (owner, _) in
                owner.dismissBottomSheet()
            }
            .disposed(by: disposeBag)
    }
}
