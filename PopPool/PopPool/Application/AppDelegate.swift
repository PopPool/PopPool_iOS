//
//  AppDelegate.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/1/24.
//

import UIKit

import GoogleMaps
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(Secrets.popPoolApiKey.rawValue)

        //DIContainer register
        registerDIContainer()
        
        //IQKeyBoardManager 사용 값 설정
        IQKeyboardManager.shared.enable = true
        //IQKeyBoardManager 오토 툴바 사용 설정
        IQKeyboardManager.shared.enableAutoToolbar = false
        //IQKeyBoardManager 배경 영역 터치시 키보드 대응 설정
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        //KakaoSDK appkey register
        RxKakaoSDK.initSDK(appKey: Secrets.kakaoAuthAppkey_Dev.rawValue)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    //카카오 로그인 세팅
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
}

