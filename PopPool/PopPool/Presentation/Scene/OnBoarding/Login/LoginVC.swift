//
//  !_!_!_.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginVC: BaseViewController {
    
    // MARK: - Components
    private let headerView = HeaderViewCPNT(title: "둘러보기", style: .text("둘러보기"))
    private let logoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    private let logoImageView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "lightLogo")
        logoView.contentMode = .scaleAspectFit
        return logoView
    }()
    private let notificationLabel: UILabel = {
        let label = UILabel()
        let text = "간편하게 SNS 로그인하고\n팝풀 서비스를 이용해보세요"
        label.numberOfLines = 0
        label.font = .KorFont(style: .bold, size: 16)
        let attributedStr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.4
        label.attributedText = NSMutableAttributedString(
            string: text,
            attributes: [.paragraphStyle: style]
        )
        label.textAlignment = .center
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    private let inquiryButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인이 어려우신가요?", for: .normal)
        button.setTitleColor(.g1000, for: .normal)
        button.titleLabel?.font = .KorFont(style: .regular, size: 12)
        return button
    }()
    private let kakaoSignInButton: ButtonCPNT = ButtonCPNT(type: .kakao, title: "카카오톡으로 로그인")
    private let appleSignInButton: ButtonCPNT = ButtonCPNT(type: .apple, title: "Apple로 로그인")
    
    // MARK: - Spacer
    // TODO: - space 상수 제거
    private lazy var spacer28 = SpacingFactory.createSpace(size: 28)
    private lazy var spacer64 = SpacingFactory.createSpace(size: 64)
    private lazy var spacer156 = SpacingFactory.createSpace(size: 156)
    
    // MARK: - Properties
    private let viewModel: LoginVM
    private let disposeBag = DisposeBag()
    
    // MARK: - init
    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension LoginVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        bind()
    }
}

// MARK: - Setup
private extension LoginVC {
     func setUpConstraints() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        headerView.leftBarButton.isHidden = true
        headerView.titleLabel.isHidden = true
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(logoStackView)
        logoStackView.addArrangedSubview(spacer64)
        logoStackView.addArrangedSubview(logoImageView)
        logoStackView.addArrangedSubview(spacer28)
        logoStackView.addArrangedSubview(notificationLabel)
        logoStackView.addArrangedSubview(spacer156)
        
        logoStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(64)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(kakaoSignInButton)
        buttonStackView.addArrangedSubview(appleSignInButton)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(logoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(116)
        }
        
        view.addSubview(inquiryButton)
        inquiryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(56)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind() {
        let input = LoginVM.Input(
            tourButtonTapped: headerView.rightBarButton.rx.tap,
            kakaoLoginButtonTapped: kakaoSignInButton.rx.tap,
            appleLoginButtonTapped: appleSignInButton.rx.tap,
            inquryButtonTapped: inquiryButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.moveToSignUpVC
            .withUnretained(self)
            .subscribe { (owner, viewModel) in
                let vc = SignUpVC(viewModel: viewModel)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.moveToHomeVC
            .withUnretained(self)
            .subscribe { (owner, loginResponse) in
                // TODO: - 로그인 성공 시 MyPageMain으로 임시 연결 추후 변경 필요
                Constants.userId = loginResponse.userId
                let useCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
                useCase.fetchMyPage(userId: loginResponse.userId)
                    .subscribe(onNext: { myPageResponse in
                        let vm = MyPageMainVM(response: myPageResponse)
                        vm.myCommentSection.sectionCellInputList = [
                            .init(cellInputList: myPageResponse.popUpInfoList.map{ .init(
                                title: $0.popUpStoreName,
                                // TODO: - isActive 부분 논의 후 수정 필요
                                isActive: false,
                                imageURL: $0.mainImageUrl)
                            })
                        ]
                        let vc = MyPageMainVC(viewModel: vm)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
