//
//  PopPoolAPIEndPoint.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    
    // MARK: - Auth API
    static func auth_tryLogin(with userCredential: Encodable, path: String) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/auth/\(path)",
            method: .post,
            bodyParameters: userCredential
        )
    }
    
    // MARK: - SignUp API
    static func signUp_checkNickName(with request: CheckNickNameRequestDTO) -> Endpoint<Bool> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup/check-nickname",
            method: .get,
            queryParameters: request
        )
    }
    
    static func signUp_fetchInterestList() -> Endpoint<InterestListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup/interests",
            method: .get
        )
    }
    
    static func signUp_trySignUp(with request: SignUpRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup",
            method: .post,
            bodyParameters: request
        )
    }
    
    // MARK: - User API
    
    /// 마이페이지 조회
    /// - Parameter userId: 유저 아이디
    /// - Returns: Endpoint<MyPageResponseDTO>
    static func user_fetchMyPage(userId: String) -> Endpoint<MyPageResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)",
            method: .get
        )
    }
    
    /// 내가 쓴 일반 코멘트 조회
    /// - Parameter userId: 유저 아이디
    /// - Parameter pageable: Pagination
    /// - Returns: Endpoint<MyPageResponseDTO>
    static func user_fetchMyComment(userId: String, pageable: PageableDTO) -> Endpoint<MyPageResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/comments",
            method: .get,
            queryParameters: pageable
        )
    }
    
    /// 회원탈퇴
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - survey: 탈퇴 설문 조사
    /// - Returns: 회원탈퇴 RequestEndpoint
    static func user_tryWithdraw(userId: String, survey: CheckedSurveyListRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/delete",
            method: .get,
            bodyParameters: survey
        )
    }
    
}
