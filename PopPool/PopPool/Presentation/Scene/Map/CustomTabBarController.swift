import UIKit

class CustomTabBarController: UITabBarController {

    private let customTabBar: CustomTabBarCPNT
    private let storeService: StoresService
    private let provider: ProviderImpl
    private let myPageResponse: GetMyPageResponse
    private let accessToken: String
    private let userUseCase: UserUseCase
    private let userId: String
    private let searchViewModel: SearchViewModel
    private let searchUseCase: SearchUseCase



    init(storeService: StoresService, provider: ProviderImpl, myPageResponse: GetMyPageResponse, accessToken: String, userUseCase: UserUseCase, userId: String, searchViewModel: SearchViewModel, searchUseCase: SearchUseCase) {
        self.storeService = storeService
        self.provider = provider
        self.myPageResponse = myPageResponse
        self.accessToken = accessToken
        self.userUseCase = userUseCase
        self.userId = userId
        self.searchViewModel = searchViewModel 
        self.searchUseCase = searchUseCase

        print("CustomTabBarController 생성됨, userId: \(userId)")  // 로그 추가

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
        let userId = UserDefaults.standard.string(forKey: "loggedInUserId") ?? ""

        let mapVM = MapVM(storeService: storeService, userId: self.userId)
        let mapVC = MapVC(viewModel: mapVM, userId: self.userId)

        let homeRepository = HomeRepositoryImpl()
        let homeUseCase = HomeUseCaseImpl(repository: homeRepository)

        let searchService = AppDIContainer.shared.resolve(type: SearchServiceProtocol.self)
        let searchRepository = SearchRepository(searchService: searchService)
        let searchUseCase = SearchUseCase(repository: searchRepository)
        let searchViewModel = SearchViewModel(searchUseCase: searchUseCase, recentSearchesViewModel: RecentSearchesViewModel())

        let homeVM = HomeVM(searchViewModel: searchViewModel, useCase: homeUseCase, searchUseCase: searchUseCase)
        let homeVC = HomeVC(viewModel: homeVM)
        print("HomeVC 생성됨")

        let myPageViewModel = MyPageMainVM()
        let myPageVC = MyPageMainVC(viewModel: myPageViewModel)
        print("MyPageMainVC 생성됨")

        // 뷰 컨트롤러들을 탭바에 설정
        viewControllers = [mapVC, homeVC, myPageVC]
        print("viewControllers 설정됨: \(viewControllers?.map { type(of: $0) } ?? [])")
    }


    private func setupCustomTabBar() {
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
