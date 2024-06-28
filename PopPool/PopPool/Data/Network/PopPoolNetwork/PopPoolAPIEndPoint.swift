//
//  PopPoolAPIEndPoint.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    
    /// 요청할 API 구조를 구성합니다
    /// - Parameters:
    ///   - userCredential: 사용자 자격 증명
    ///   - path: API 경로
    /// - Returns: 로그인 응답 DTO를 반환하는 Endpoint
    static func tryLogin(with userCredential: Encodable, path: String) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: "http://localhost:8080",
            path: "/auth/\(path)",
            method: .post,
            bodyParameters: userCredential
        )
    }
    
//    static func trySignUp(user: TrySignUpRequestDTO, credential: MyAuthenticationCredential) -> Endpoint<FetchGendersResponseDTO> {
//        return Endpoint(
//            baseURL: "http://localhost:8080",
//            path: "/signup",
//            method: .post,
//            bodyParameters: user,
//            headers: ["Authorization": "Bearer \(credential.accessToken)"]
//        )
//    }
    
    static func checkNickName(with request: CheckNickNameRequestDTO , credential: MyAuthenticationCredential) -> Endpoint<Bool> {
        return Endpoint(
            baseURL: "http://localhost:8080",
            path: "/signup/check-nickname",
            method: .get,
            queryParameters: request,
            headers: ["Authorization": "Bearer \(credential.accessToken)"]
        )
    }
    
    static func fetchInterestList(credential: MyAuthenticationCredential) -> Endpoint<FetchInterestListResponseDTO> {
        return Endpoint(
            baseURL: "http://localhost:8080",
            path: "/signup/interests",
            method: .get,
            headers: ["Authorization": "Bearer \(credential.accessToken)"]
        )
    }
    
    static func fetchGenders(credential: MyAuthenticationCredential) -> Endpoint<FetchGendersResponseDTO> {
        return Endpoint(
            baseURL: "http://localhost:8080",
            path: "/signup/genders",
            method: .get,
            headers: ["Authorization": "Bearer \(credential.accessToken)"]
        )
    }
}
