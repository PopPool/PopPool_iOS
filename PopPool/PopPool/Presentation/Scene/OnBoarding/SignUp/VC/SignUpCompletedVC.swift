//
//  SignUpCompletedVC.swift
//  PopPool
//
//  Created by Porori on 7/3/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class SignUpCompletedVC: UIViewController {
    
    // MARK: - Properties
    let headerView = HeaderViewCPNT(title: "", style: .text("취소"))
    let iconImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "check_fill_signUp")?.withTintColor(UIColor.blu500)
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let tagNotificationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var notificationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(spacer80)
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(spacer32)
        stack.addArrangedSubview(notificationLabel)
        stack.addArrangedSubview(spacer16)
        stack.addArrangedSubview(tagNotificationLabel)
        return stack
    }()
    
    let confirmButton = ButtonCPNT(type: .primary, title: "바로가기")
    let spacer80 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._80px)
    let spacer32 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._32px)
    let spacer16 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._16px)
    
    let userName: String?
    var categoryTags: [String]?
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(nickname: String?, tags: [String]?) {
        self.userName = nickname
        self.categoryTags = tags
        super.init(nibName: nil, bundle: nil)
        setUpConstraints()
        setNickName()
        setCategory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self, #function)
    }
}

extension SignUpCompletedVC {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        bind()
    }
}

extension SignUpCompletedVC {
    
    // MARK: - Methods
    private func setNickName() {
        let greeting = "가입완료!\n"
        let description = "님의\n피드를 확인해보세요"
        let text = greeting + (userName ?? "홍길동") + description
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        let attributedString = NSMutableAttributedString(string: text)
        let targetRange = (text as NSString).range(of: userName ?? "홍길동")
        let fullRange = (text as NSString).range(of: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blu500.cgColor, range: targetRange)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        notificationLabel.attributedText = attributedString
        
        notificationLabel.font = UIFont.KorFont(style: .bold, size: 20)
        notificationLabel.textAlignment = .center
        notificationLabel.numberOfLines = 0
    }
    
    private func setCategory() {
        let description = "와\n연관된 팝업스토어 정보를 안내해드릴게요"
        let tags = categoryTags?.map { $0 } ?? []
        let groupTags = tags.joined(separator: ", ")
        let text = groupTags + description
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: groupTags)
        let full = (text as NSString).range(of: text)
        attributedText.addAttribute(.foregroundColor, value: UIColor.g600.cgColor, range: full)
        attributedText.addAttribute(.font, value: UIFont.KorFont(style: .bold, size: 15)!, range: range)
        attributedText.addAttribute(.paragraphStyle, value: style, range: full)
        tagNotificationLabel.attributedText = attributedText
        tagNotificationLabel.numberOfLines = 0
        tagNotificationLabel.textAlignment = .center
    }
    
    private func setUpConstraints() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        headerView.rightBarButton.isHidden = true
        headerView.leftBarButton.isHidden = true
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(notificationStack)
        notificationStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide._48px)
        }
    }
    
    private func dismissVC() {
        // 메인 화면으로 navigationController를 교체
        let vc = LoginVC()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    private func bind() {
        confirmButton.rx.tap
            .bind { [weak self] in
                self?.dismissVC()
            }
            .disposed(by: disposeBag)
    }
}
