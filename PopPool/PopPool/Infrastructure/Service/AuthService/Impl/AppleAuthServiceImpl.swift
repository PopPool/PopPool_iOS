//
//  AppleAuthServiceImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift
import AuthenticationServices

final class AppleAuthServiceImpl: NSObject, AuthService  {
    
    // 사용자 자격 증명 정보를 방출할 subject
    private var userCredentialObserver = PublishSubject<UserCredential>()
    
    func fetchUserCredential() -> Observable<UserCredential> {
        performRequest()
        return userCredentialObserver
    }
    
    // Apple 인증 요청을 수행하는 함수
    private func performRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AppleAuthServiceImpl: ASAuthorizationControllerPresentationContextProviding,
                                ASAuthorizationControllerDelegate 
{
    
    // 인증 컨트롤러의 프레젠테이션 앵커를 반환하는 함수
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.windows.first else { return UIWindow() }
        return window
    }
    
    // 인증 성공 시 호출되는 함수
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let token = appleIDCredential.identityToken {
                let id = appleIDCredential.user
                guard let stringToken = String(data: token, encoding: .utf8) else { return }
                // 성공적으로 사용자 자격 증명을 방출
                userCredentialObserver.onNext(.init(id: id, token: stringToken))
                userCredentialObserver.onCompleted()
            } else {
                // 토큰이 없는 경우 오류 방출
                userCredentialObserver.onError(AuthError.unknownError)
            }
        default:
            break
        }
    }
    
    // 인증 실패 시 호출되는 함수
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        userCredentialObserver.onError(error)
    }
}
