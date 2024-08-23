import UIKit

class CustomTabBarController: UITabBarController {

    private let customTabBar: CustomTabBarCPNT
    private let storeService: StoresService
    private let provider: ProviderImpl
    private let myPageResponse: GetMyPageResponse
    private let accessToken: String

    init(storeService: StoresService, provider: ProviderImpl, myPageResponse: GetMyPageResponse, accessToken: String) {
        print("CustomTabBarController 초기화 시작")
        self.storeService = storeService
        self.provider = provider
        self.myPageResponse = myPageResponse
        self.accessToken = accessToken
        print("CustomTabBarController 초기화 - myPageResponse: \(myPageResponse)")
        print("CustomTabBarController 초기화 - accessToken: \(accessToken)")
        self.customTabBar = CustomTabBarCPNT(items: [.map, .my])
        super.init(nibName: nil, bundle: nil)
        print("CustomTabBarController 초기화 완료")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CustomTabBarController viewDidLoad 시작")
        setupViewControllers()
        print("setupViewControllers 완료")
        setupCustomTabBar()
        print("setupCustomTabBar 완료")
    }

    private func setupViewControllers() {
        print("setupViewControllers 시작")
        let mapViewModel = MapVM(storeService: storeService)
        let mapVC = MapVC(viewModel: mapViewModel)
        print("MapVC 생성 완료")

        let myPageViewModel = MyPageMainVM(response: myPageResponse)
        let myPageVC = MyPageMainVC(viewModel: myPageViewModel)
        print("MyPageMainVC 생성 완료")

        viewControllers = [mapVC, myPageVC]
        print("viewControllers 설정 완료")
    }

    private func setupCustomTabBar() {
        print("setupCustomTabBar 시작")
        tabBar.isHidden = true

        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(83) // 탭바 높이 + 안전 영역
        }

        customTabBar.onItemSelected = { [weak self] index in
            self?.selectedIndex = index
            print("탭바 아이템 선택됨: \(index)")
        }
        print("setupCustomTabBar 완료")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews 시작")

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
