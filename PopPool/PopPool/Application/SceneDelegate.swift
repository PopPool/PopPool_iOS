//
//  SceneDelegate.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController()

        // 기존 코드 (주석 처리)
//        window?.rootViewController = UINavigationController(rootViewController: ViewController(viewModel: ViewControllerViewModel()))
        window?.rootViewController = UINavigationController(rootViewController: LoginVC(viewModel: LoginVM()))
        //window?.rootViewController = UINavigationController(rootViewController: BlockedUserVC(blockCount: 3))
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
