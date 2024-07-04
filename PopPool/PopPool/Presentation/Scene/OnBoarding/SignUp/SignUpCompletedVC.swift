//
//  SignUpCompletedVC.swift
//  PopPool
//
//  Created by Porori on 7/3/24.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpCompletedVC: UIViewController {

    // MARK: - Components

    private let headerView = HeaderViewCPNT(title: "", style: .text("취소"))
    private let iconImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "check_fill_signUp")?.withTintColor(UIColor.blu500)
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()

    private let notificationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let tagNotificationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // 완료 화면 전체 프로퍼티를 담는 Stackview
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

    // MARK: - Properties

    private let confirmButton = ButtonCPNT(type: .primary, title: "바로가기")
    private let spacer80 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._80px)
    private let spacer32 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._32px)
    private let spacer16 = SpacingFactory.shared.createSpace(size: Constants.spaceGuide._16px)

    private let userName: String?
    private let categoryTags: [String]?
    private let disposeBag = DisposeBag()

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

private extension SignUpCompletedVC {

    // MARK: - Methods

    /// 닉네임 폰트, 스타일을 커스텀 적용하는 메서드
    func setNickName() {
        let greeting = "가입완료!\n"
        let description = "님의\n피드를 확인해보세요"
        let text = greeting + (userName ?? "홍길동") + description

        // 전체 안내문과 닉네임에 각각 font와 컬러를 스타일로 적용합니다
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        let attributedString = NSMutableAttributedString(string: text)
        let targetRange = (text as NSString).range(of: userName ?? "홍길동")
        let fullRange = (text as NSString).range(of: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blu500.cgColor, range: targetRange)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        attributedString.addAttribute(.font, value: UIFont.KorFont(style: .bold, size: 20)!, range: fullRange)

        notificationLabel.attributedText = attributedString
        notificationLabel.numberOfLines = 0
        notificationLabel.textAlignment = .center
    }

    /// 카테고리에 폰트 및 스타일을 적용하는 메서드
    func setCategory() {
        let description = "와\n연관된 팝업스토어 정보를 안내해드릴게요"
        let tags = categoryTags?.map { $0 } ?? []
        let groupTags = tags.joined(separator: ", ")
        let text = groupTags + description

        // 카테고리에 각각 알맞는 font와 컬러를 스타일로 적용합니다
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: groupTags)
        let full = (text as NSString).range(of: text)
        tagNotificationLabel.font = .KorFont(style: .regular, size: 15)
        attributedText.addAttribute(.foregroundColor, value: UIColor.g600.cgColor, range: full)
        attributedText.addAttribute(.font, value: UIFont.KorFont(style: .bold, size: 15)!, range: range)
        attributedText.addAttribute(.paragraphStyle, value: style, range: full)

        tagNotificationLabel.attributedText = attributedText
        tagNotificationLabel.numberOfLines = 0
        tagNotificationLabel.textAlignment = .center
    }

    /// 컴포넌트별 제약을 잡습니다
    func setUpConstraints() {
        view.backgroundColor = .systemBackground

        view.addSubview(headerView)
        headerView.rightBarButton.isHidden = true
        headerView.leftBarButton.isHidden = true
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        view.addSubview(notificationStack)
        notificationStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.top.equalTo(headerView.snp.bottom)
        }

        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide._20px)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide._48px)
        }
    }

    /// 완료 버튼이 탭된 이후 현재 navigationController를 이후 넘어가는 loginVC로 교체됩니다
    func dismissVC() {
        let vc = LoginVC()
        navigationController?.setViewControllers([vc], animated: true)
    }

    func bind() {
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.dismissVC()
            }
            .disposed(by: disposeBag)
    }
}
