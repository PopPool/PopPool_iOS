//
//  SceneDelegate.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

//
//  SceneDelegate.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import UIKit

import RxSwift
import RxCocoa

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var disposeBag = DisposeBag()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        isDevMode()
        let navigationController = UINavigationController()

        // 기존 코드 (주석 처리)
//        window?.rootViewController = UINavigationController(rootViewController: ViewController(viewModel: ViewControllerViewModel()))
//        window?.rootViewController = UINavigationController(rootViewController: LoginVC(viewModel: LoginVM()))
        let startVC = MyPageMainVC(viewModel: MyPageMainVM())
//        startVC.popUpStoreId.accept(25)
        window?.rootViewController = UINavigationController(rootViewController: startVC)
        
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
    
    func isDevMode() {
        var userID = "3597441738@kakao"
        var accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBQ0NFU1MiLCJpYXQiOjE3MjU5NjY4OTUsImV4cCI6MTcyODM4NjA5NSwiaXNUZW1wb3JhcnkiOmZhbHNlLCJ1c2VySWQiOiIzNTk3NDQxNzM4QGtha2FvIn0.sr5Tp6s2CO1odd6DMP5zfBuJnd53IxoC_1iCoX59CQzYC00nqlswiR50gukGnD4-bvq7bvJVnnOjk266MkTzaA"
        var refreshToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJSRUZSRVNIIiwiaWF0IjoxNzI1OTY2ODk1LCJleHAiOjE3MjcxNzY0OTUsImlzVGVtcG9yYXJ5IjpmYWxzZSwidXNlcklkIjoiMzU5NzQ0MTczOEBrYWthbyJ9.oXnlDlv-u0nxigjDhsXJhK3w1eYUxKonO5lIuZLgOIy01pCF839OmhpGThSqdj4IZxFfjTTKn0utHK3kqOsM2w"
        var keychainService = KeyChainServiceImpl()
        Constants.userId = userID
        keychainService.saveToken(type: .accessToken, value: accessToken)
            .subscribe {
                print("AccessToken Dev Mode")
            }
            .disposed(by: disposeBag)
        
        keychainService.saveToken(type: .refreshToken, value: refreshToken)
            .subscribe {
                print("refreshToken Dev Mode")
            }
            .disposed(by: disposeBag)
    }
}
