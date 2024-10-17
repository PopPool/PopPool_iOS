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
//    private let headerView = HeaderViewCPNT(title: "둘러보기", style: .text("둘러보기"))
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
    private let provider: ProviderImpl
    private let tokenInterceptor: TokenInterceptor


    // MARK: - init
    init(viewModel: LoginVM, provider: ProviderImpl, tokenInterceptor: TokenInterceptor) {
        self.viewModel = viewModel
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor

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
        showLastLogin()
    }
}

// MARK: - Setup
private extension LoginVC {
    func setUpConstraints() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
//        headerView.leftBarButton.isHidden = true
//        headerView.titleLabel.isHidden = true

//        view.addSubview(headerView)
//        headerView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing.equalToSuperview()
//        }

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
//            tourButtonTapped: headerView.rightBarButton.rx.tap,
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
            .subscribe(onNext: { (owner, loginResponse) in
                // 로그인 성공 시 처리
                print("로그인 성공, userId: \(loginResponse.userId), accessToken: \(loginResponse.accessToken)")
                Constants.userId = loginResponse.userId
                UserDefaults.standard.set(loginResponse.userId, forKey: "loggedInUserId")

                let keyChainService = KeyChainServiceImpl()

                // 토큰 저장
                keyChainService.saveToken(type: .accessToken, value: loginResponse.accessToken)
                    .subscribe(onCompleted: {
                        print("accessToken saved")
                    })
                    .disposed(by: self.disposeBag)

                keyChainService.saveToken(type: .refreshToken, value: loginResponse.refreshToken)
                    .subscribe(onCompleted: {
                        print("refreshToken saved")
                    })
                    .disposed(by: self.disposeBag)


                let useCase = AppDIContainer.shared.resolve(type: UserUseCase.self)
                useCase.fetchMyPage(userId: loginResponse.userId)
                    .subscribe(onNext: { myPageResponse in
                        let storeService = AppDIContainer.shared.resolve(type: StoresService.self)
                        let provider = AppDIContainer.shared.resolve(type: ProviderImpl.self)
                        let searchUseCase = SearchUseCase(repository: AppDIContainer.shared.resolve(type: SearchRepositoryProtocol.self))
                        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, recentSearchesViewModel: RecentSearchesViewModel())

                        let customTabBarController = CustomTabBarController(
                            storeService: storeService,
                            provider: provider,
                            tokenInterceptor: TokenInterceptor(),
                            myPageResponse: myPageResponse,
                            accessToken: loginResponse.accessToken,
                            userUseCase: useCase,
                            userId: loginResponse.userId,
                            searchViewModel: searchViewModel,
                            searchUseCase: searchUseCase
                        )

                        owner.navigationController?.setViewControllers([customTabBarController], animated: true)


                        // MapVC 생성
                        let mapViewModel = MapVM(storeService: storeService, userId: Constants.userId)
                        let mapVC = MapVC(viewModel: mapViewModel, userId: loginResponse.userId)

                        let homeRepository = HomeRepositoryImpl()
                        let homeUseCase = HomeUseCaseImpl(repository: homeRepository)
                        let homeVM = HomeVM(searchViewModel: searchViewModel, useCase: homeUseCase, searchUseCase: searchUseCase)
                        let homeVC = HomeVC(viewModel: homeVM, provider: provider, tokenInterceptor: TokenInterceptor())

                        let vm = MyPageMainVM()
                        vm.myCommentSection.sectionCellInputList = [
                            .init(cellInputList: myPageResponse.popUpInfoList.map { .init(

                                title: $0.popUpStoreName,
                                isActive: false,
                                imageURL: $0.mainImageUrl)
                            })
                        ]
                        let myPageVC = MyPageMainVC(viewModel: vm)

                        // CustomTabBarController에 뷰컨트롤러 설정
                        customTabBarController.viewControllers = [mapVC, homeVC, myPageVC]

                        // 네비게이션 스택 교체
                        owner.navigationController?.setViewControllers([customTabBarController], animated: true)
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        output.moveToInquryVC
            .withUnretained(self)
            .subscribe { (owner, _) in
                if let url = URL(string: "mailto: jacks222@naver.com") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func showLastLogin() {
        let service = UserDefaultService()
        service.fetch(key: "lastLogin")
            .subscribe { [weak self] socialType in
                switch socialType {
                case .success(let social):
                    if social == "KAKAO" {
                        self?.kakaoSignInButton.showToolTip(color: .w100, direction: .pointDown, text: "최근에 이 방법으로 로그인했어요")
                    } else if social == "APPLE" {
                        self?.appleSignInButton.showToolTip(color: .w100, direction: .pointUp, text: "최근에 이 방법으로 로그인했어요")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

