//
//  PopPoolAPIEndPoint.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    
    // MARK: - Auth API
    
    /// 로그인을 시도합니다.
    /// - Parameters:
    ///   - userCredential: 사용자 자격 증명
    ///   - path: 경로
    /// - Returns: Endpoint<LoginResponseDTO>
    static func auth_tryLogin(with userCredential: Encodable, path: String) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/auth/\(path)",
            method: .post,
            bodyParameters: userCredential
        )
    }
    
    // MARK: - SignUp API
    
    /// 닉네임 중복을 확인합니다.
    /// - Parameter request: 닉네임 체크 요청 DTO
    /// - Returns: Endpoint<Bool>
    static func signUp_checkNickName(with request: CheckNickNameRequestDTO) -> Endpoint<Bool> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup/check-nickname",
            method: .get,
            queryParameters: request
        )
    }
    
    /// 관심사 목록을 가져옵니다.
    /// - Returns: Endpoint<GetInterestListResponseDTO>
    static func signUp_getCategoryList() -> Endpoint<GetCategoryListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup/categories",
            method: .get
        )
    }
    
    /// 회원가입을 시도합니다.
    /// - Parameter request: 회원가입 요청 DTO
    /// - Returns: RequestEndpoint
    static func signUp_trySignUp(with request: SignUpRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/signup",
            method: .post,
            bodyParameters: request
        )
    }
    
    // MARK: - User API, 마이페이지 회원 API
    
    /// 마이페이지 조회
    /// - Parameter userId: 유저 아이디
    /// - Returns: Endpoint<GetMyPageResponseDTO>
    static func user_getMyPage(userId: String) -> Endpoint<GetMyPageResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/my-page",
            method: .get
        )
    }
    
    /// 내가 쓴 일반 코멘트를 조회합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - request: Pagination 요청 DTO
    /// - Returns: Endpoint<GetMyCommentResponseDTO>
    static func user_getMyComment(
        userId: String,
        request: GetMyCommentRequestDTO
    ) -> Endpoint<GetMyCommentResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/comments",
            method: .get,
            queryParameters: request
        )
    }
    
    /// 회원탈퇴를 시도합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - survey: 탈퇴 설문 조사 요청 DTO
    /// - Returns: 회원탈퇴 RequestEndpoint
    static func user_tryWithdraw(userId: String, survey: CheckedSurveyListRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/delete",
            method: .get,
            bodyParameters: survey
        )
    }
    
    /// 내가 댓글을 단 팝업 리스트를 조회합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - pageable: Pagination 요청 DTO
    /// - Returns: Endpoint<GetMyCommentedPopUpStoreListResponseDTO>
    static func user_getMyCommentedPopUpStoreList(
        userId: String,
        request: GetMyCommentedPopUpStoreListRequestDTO
    ) -> Endpoint<GetMyCommentedPopUpStoreListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/popupstores/with-comments",
            method: .get,
            queryParameters: request
        )
    }
    
    /// 최근 본 팝업 리스트를 조회합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - pageable: Pagination 요청 DTO
    /// - Returns: Endpoint<GetMyRecentViewPopUpStoreListResponseDTO>
    static func user_getMyRecentViewPopUpStoreList(
        userId: String,
        request: GetMyRecentViewPopUpStoreListRequestDTO
    ) -> Endpoint<GetMyRecentViewPopUpStoreListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/recent-popupstores",
            method: .get,
            queryParameters: request
        )
    }
    
    /// 유저를 차단합니다.
    /// - Parameter request: 유저 차단 요청 DTO
    /// - Returns: RequestEndpoint
    static func user_block(request: UserBlockRequestDTO) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/block",
            method: .post,
            queryParameters: request
        )
    }
    
    /// 차단된 유저 리스트를 조회합니다.
    /// - Parameter request: 차단된 유저 리스트 요청 DTO
    /// - Returns: Endpoint<GetBlockedUserListResponseDTO>
    static func user_getBlockedUserList(
        request: GetBlockedUserListRequestDTO
    ) -> Endpoint<GetBlockedUserListResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/blocked",
            method: .get,
            queryParameters: request
        )
    }
    
    /// 로그아웃을 시도합니다.
    /// - Returns: RequestEndpoint
    static func user_logOut() -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/logout",
            method: .post
        )
    }
    
    /// 유저 차단을 해제합니다.
    /// - Parameter request: 유저 차단 해제 요청 DTO
    /// - Returns: RequestEndpoint
    static func user_unblock(
        request: UserUnblockRequestDTO
    ) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/unblock",
            method: .delete,
            queryParameters: request
        )
    }
    
    /// 탈퇴 설문 목록을 조회합니다.
    /// - Returns: Endpoint<GetWithDrawlSurveyResponse>
    static func user_getWithdrawlSurveryList() -> Endpoint<GetWithDrawlSurveyResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/withdrawl/surveys",
            method: .get
        )
    }
    
    // MARK: - User API, 회원 프로필 API
    
    /// 유저 프로필을 조회합니다.
    /// - Parameter userId: 유저 아이디
    /// - Returns: Endpoint<GetProfileResponseDTO>
    static func user_getProfile(userId: String) -> Endpoint<GetProfileResponseDTO> {
        return Endpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/profiles",
            method: .get
        )
    }
    
    /// 유저 관심사를 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - request: 관심사 업데이트 요청 DTO
    /// - Returns: RequestEndpoint
    static func user_updateMyInterest(
        userId: String,
        request: UpdateMyInterestRequestDTO
    ) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/interests",
            method: .put,
            bodyParameters: request
        )
    }
    
    /// 유저 프로필을 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - request: 프로필 업데이트 요청 DTO
    /// - Returns: RequestEndpoint
    static func user_updateMyProfile(
        userId: String,
        request: UpdateMyProfileRequestDTO
    ) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/profiles",
            method: .put,
            bodyParameters: request
        )
    }
    
    /// 유저 맞춤 정보를 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - request: 맞춤 정보 업데이트 요청 DTO
    /// - Returns: RequestEndpoint
    static func user_updateMyTailoredInfo(
        userId: String,
        request: UpdateMyTailoredInfoRequestDTO
    ) -> RequestEndpoint {
        return RequestEndpoint(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/users/\(userId)/tailored-info",
            method: .put,
            bodyParameters: request
        )
    }
    /// 팝업 스토어 목록을 조회합니다.
       /// - Returns: Endpoint<[PopUpStoreDTO]>
       static func map_fetchPopUpStores() -> Endpoint<[PopUpStoreDTO]> {
           return Endpoint(
               baseURL: Secrets.popPoolBaseUrl.rawValue,
               path: "/map/popupstores",
               method: .get
           )
       }
   }
