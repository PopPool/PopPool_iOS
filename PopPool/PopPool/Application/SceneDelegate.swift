import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)

            let container = AppDIContainer.shared

            // Provider 인스턴스 생성 (ProviderImpl 대신 Provider 인터페이스로 가져오기)
            let provider = container.resolve(type: Provider.self)

            // MapRepository 생성
            let mapRepository = MapRepositoryImpl(provider: provider)

            // StoresService 가져오기
            let storeService = container.resolve(type: StoresService.self)

            // 기존 코드 (로그인 화면을 루트 뷰 컨트롤러로 설정)
            window?.rootViewController = UINavigationController(rootViewController: LoginVC(viewModel: LoginVM()))

            // 맵뷰를 루트 뷰 컨트롤러로 설정하는 부분은 주석 처리
            // let mapViewModel = MapVM(storeService: storeService)
            // let mapViewController = MapVC(viewModel: mapViewModel)
            // let mapNavController = UINavigationController(rootViewController: mapViewController)
            // window?.rootViewController = mapNavController

            window?.makeKeyAndVisible()
        }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
