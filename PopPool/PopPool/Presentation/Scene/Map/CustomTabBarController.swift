import UIKit

class CustomTabBarController: UITabBarController {

    private let customTabBar: CustomTabBarCPNT
    private let storeService: StoresService
    private let provider: ProviderImpl
    private let myPageResponse: GetMyPageResponse
    private let accessToken: String
    private let userUseCase: UserUseCase

    init(storeService: StoresService, provider: ProviderImpl, myPageResponse: GetMyPageResponse, accessToken: String, userUseCase: UserUseCase) {
        self.storeService = storeService
        self.provider = provider
        self.myPageResponse = myPageResponse
        self.accessToken = accessToken
        self.userUseCase = userUseCase
        self.customTabBar = CustomTabBarCPNT(items: [.map, .home, .my])
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCustomTabBar()
    }

    private func setupViewControllers() {

        let mapViewModel = MapVM(storeService: storeService)
        let mapVC = MapVC(viewModel: mapViewModel)

        let homeVM = HomeVM()
        let loggedHomeVC = LoggedHomeVC(viewModel: homeVM)
        print("LoggedHomeVC 생성됨")

        let myPageViewModel = MyPageMainVM(response: myPageResponse, userUseCase: userUseCase)
        let myPageVC = MyPageMainVC(viewModel: myPageViewModel)
        print("MyPageMainVC 생성됨")


        // 뷰 컨트롤러들을 탭바에 설정
        viewControllers = [mapVC, loggedHomeVC, myPageVC]
        print("viewControllers 설정됨: \(viewControllers?.map { type(of: $0) } ?? [])")

    }

    private func setupCustomTabBar() {
        //        print("setupCustomTabBar 시작")
        tabBar.isHidden = true

        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83)
        }

        customTabBar.onItemSelected = { [weak self] index in
            guard let self = self else { return }
            print("탭 선택됨: \(index)")
            if index < self.viewControllers?.count ?? 0 {
                let selectedVC = self.viewControllers?[index]
                print("선택된 VC: \(type(of: selectedVC))")
                self.selectedViewController = selectedVC
            } else {
                print("오류: 유효하지 않은 탭 인덱스")
            }
        }

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for viewController in viewControllers ?? [] {
            viewController.view.frame = CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: view.frame.height - customTabBar.frame.height
            )
        }
        print("viewDidLayoutSubviews 완료")
    }
}
