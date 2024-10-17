////
////  SceneDelegate.swift
////  PopPool
////
////  Created by SeoJunYoung on 6/1/24.
////
//
//import UIKit
//import RxSwift
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//    private let disposeBag = DisposeBag()
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//
//        let navigationController = UINavigationController()
//        autoLogin()
//
//        // 기존 코드 (주석 처리)
//        //        window?.rootViewController = UINavigationController(rootViewController: ViewController(viewModel: ViewControllerViewModel()))
//        //        window?.rootViewController = UINavigationController(rootViewController: LoginVC(viewModel: LoginVM()))
//        //window?.rootViewController = UINavigationController(rootViewController: BlockedUserVC(blockCount: 3))
//        let provider = ProviderImpl()
//        let tokenInterceptor = TokenInterceptor()
//        let keyChainService = KeyChainServiceImpl()
//        let storeService = StoresService(provider: provider, tokenInterceptor: tokenInterceptor, keyChainService: keyChainService)
//
//        let mapVM = MapVM(storeService: storeService, userId: Constants.userId)
//        let mainVC = MapVC(viewModel: mapVM, userId: Constants.userId)
//
//        navigationController.viewControllers = [mainVC]
//
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
//    }
//    private func autoLogin() {
//        let userId = "3597480470@kakao"
//        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBQ0NFU1MiLCJpYXQiOjE3MjQ3MTEzNzQsImV4cCI6MTcyNzEzMDU3NCwiaXNUZW1wb3JhcnkiOmZhbHNlLCJ1c2VySWQiOiIzNTk3NDgwNDcwQGtha2FvIn0.atTcdAnhlpulGUlWX8ORbgslDMMtJI2KGUoe_86kJ8HpjJ3ytOjkgHAsKIs6CldqFDg60Zkt8fQhWfeCNXkuMQ"
//        let refreshToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBQ0NFU1MiLCJpYXQiOjE3MjQ3MTEzNzQsImV4cCI6MTcyNzEzMDU3NCwiaXNUZW1wb3JhcnkiOmZhbHNlLCJ1c2VySWQiOiIzNTk3NDgwNDcwQGtha2FvIn0.atTcdAnhlpulGUlWX8ORbgslDMMtJI2KGUoe_86kJ8HpjJ3ytOjkgHAsKIs6CldqFDg60Zkt8fQhWfeCNXkuMQ"
//
//        let keyChainService = KeyChainServiceImpl()
//        Constants.userId = userId
//        keyChainService.saveToken(type: .accessToken, value: accessToken)
//            .subscribe(onCompleted: {
//                print("accessToken saved")
//            })
//            .disposed(by: disposeBag)
//
//        keyChainService.saveToken(type: .refreshToken, value: refreshToken)
//            .subscribe(onCompleted: {
//                print("refreshToken saved")
//            })
//            .disposed(by: disposeBag)
//    }
//
//    func sceneDidDisconnect(_ scene: UIScene) {
//    }
//
//    func sceneDidBecomeActive(_ scene: UIScene) {
//    }
//
//    func sceneWillResignActive(_ scene: UIScene) {
//    }
//
//    func sceneWillEnterForeground(_ scene: UIScene) {
//    }
//
//    func sceneDidEnterBackground(_ scene: UIScene) {
//    }
//
//}
// 개발자
//
//  SceneDelegate.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        // provider와 tokenInterceptor를 생성
        let provider = ProviderImpl()
        let tokenInterceptor = TokenInterceptor()

        // LoginVC를 provider와 tokenInterceptor와 함께 초기화
        let splashVC = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashVC)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
