//
//  SignUpCompletedVC.swift
//  PopPool
//
//  Created by Porori on 7/3/24.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpCompletedVC: BaseViewController {

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
    private let spacer80 = SpacingFactory.createSpace(size: Constants.spaceGuide.large200)
    private let spacer32 = SpacingFactory.createSpace(size: Constants.spaceGuide.medium100)
    private let spacer16 = SpacingFactory.createSpace(size: Constants.spaceGuide.small100)

    private let userName: String?
    private let categoryTags: [String]?
    private let disposeBag = DisposeBag()

    private let provider: ProviderImpl
       private let tokenInterceptor: TokenInterceptor
       private let storeService: StoresService
       private let userUseCase: UserUseCase
    private let userId: String
       private let accessToken: String
    private let refreshToken: String


    // MARK: - Initializer

    init(nickname: String?,
           tags: [String]?,
           provider: ProviderImpl,
           tokenInterceptor: TokenInterceptor,
           storeService: StoresService,
           userUseCase: UserUseCase,
           userId: String,
           accessToken: String,
           refreshToken: String) {
          self.userName = nickname
          self.categoryTags = tags
          self.provider = provider
          self.tokenInterceptor = tokenInterceptor
          self.storeService = storeService
          self.userUseCase = userUseCase
          self.userId = userId
          self.accessToken = accessToken
          self.refreshToken = refreshToken
          super.init()
          setUpConstraints()
          setNickName()
          setCategory()
      }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide.small200)
            make.top.equalTo(headerView.snp.bottom)
        }

        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.leading.trailing.equalToSuperview().inset(Constants.spaceGuide.small200)
            make.bottom.equalToSuperview().inset(Constants.spaceGuide.medium400)
        }
    }

    /// 완료 버튼이 탭된 이후 현재 navigationController를 이후 넘어가는 loginVC로 교체됩니다
    func dismissVC() {
//        let vc = LoginVC(viewModel: LoginVM())
//        navigationController?.setViewControllers([vc], animated: true)
    }

    func moveToCustomTabBarController() {
        // 회원가입 완료 시 처리
        print("회원가입 완료, userId: \(userId), accessToken: \(accessToken)")
           Constants.userId = userId
           UserDefaults.standard.set(userId, forKey: "loggedInUserId")

           let keyChainService = KeyChainServiceImpl()

           // accessToken 저장
           keyChainService.saveToken(type: .accessToken, value: accessToken)
               .subscribe(onCompleted: { [weak self] in
                   guard let self = self else { return }
                   print("accessToken saved: \(self.accessToken)")
               })
               .disposed(by: disposeBag)

           // refreshToken 저장
           keyChainService.saveToken(type: .refreshToken, value: refreshToken)
               .subscribe(onCompleted: { [weak self] in
                   guard let self = self else { return }
                   print("refreshToken saved: \(self.refreshToken)")
               })
               .disposed(by: disposeBag)

           // 나머지 코드는 그대로 유지
           userUseCase.fetchMyPage(userId: userId)
               .subscribe(onNext: { [weak self] myPageResponse in
                   guard let self = self else { return }

                let storeService = AppDIContainer.shared.resolve(type: StoresService.self)
                let provider = AppDIContainer.shared.resolve(type: ProviderImpl.self)
                let searchUseCase = SearchUseCase(repository: AppDIContainer.shared.resolve(type: SearchRepositoryProtocol.self))
                let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, recentSearchesViewModel: RecentSearchesViewModel())

                let customTabBarController = CustomTabBarController(
                    storeService: storeService,
                    provider: provider,
                    tokenInterceptor: TokenInterceptor(),
                    myPageResponse: myPageResponse,
                    userUseCase: self.userUseCase,
                    userId: self.userId,
                    searchViewModel: searchViewModel,
                    searchUseCase: searchUseCase
                )

                // MapVC 생성
                let mapViewModel = MapVM(storeService: storeService, userId: self.userId)
                let mapVC = MapVC(viewModel: mapViewModel, userId: self.userId)

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
                self.navigationController?.setViewControllers([customTabBarController], animated: true)
            })
            .disposed(by: disposeBag)
        print("userId: \(userId), accessToken: \(accessToken), refreshToken: \(refreshToken)")

    }

    func bind() {
        confirmButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.moveToCustomTabBarController()
            }
            .disposed(by: disposeBag)
    }
}
