//
//  UserRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation
import RxSwift

struct UserRepositoryImpl: UserRepository {
    
    private let provider = AppDIContainer.shared.resolve(type: Provider.self)
    private let tokenInterceptor = TokenInterceptor()
    private let requestTokenInterceptor = RequestTokenInterceptor()
    
    func fetchMyPage(
        userId: String
    ) -> Observable<GetMyPageResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getMyPage(userId: userId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchMyComment(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getMyComment(
            userId: userId,
            request: .init(page: page, size: size, sort: sort)
        )
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func tryWithdraw(userId: String, surveyList: [Survey]) -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_tryWithdraw(
            userId: userId,
            survey: .init(checkedSurveyList: surveyList.map({ $0.toRequestDTO() }))
        )
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func fetchMyCommentedPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentedPopUpStoreListResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getMyCommentedPopUpStoreList(
            userId: userId, 
            request: .init(page: page, size: size, sort: sort)
        )
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchMyRecentViewPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyRecentViewPopUpStoreListResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getMyRecentViewPopUpStoreList(
            userId: userId,
            request: .init(page: page, size: size, sort: sort)
        )
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func userBlock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_block(request: .init(blockerUserId: blockerUserId, blockedUserId: blockedUserId))
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func fetchBlockedUserList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetBlockedUserListResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getBlockedUserList(request: .init(userId: userId, page: page, size: size, sort: sort))
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func logOut() -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_logOut()
        return provider.request(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func userUnblock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_unblock(request: .init(blockerUserId: blockerUserId, blockedUserId: blockedUserId))
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func fetchWithdrawlSurveryList() -> Observable<GetWithDrawlSurveyResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getWithdrawlSurveryList()
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func fetchProfile(userId: String) -> Observable<GetProfileResponse> {
        let endPoint = PopPoolAPIEndPoint.user_getProfile(userId: userId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map({ $0.toDomain() })
    }
    
    func updateMyInterest(
        userId: String,
        interestsToAdd: [Int64],
        interestsToDelete: [Int64],
        interestsToKeep: [Int64]
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_updateMyInterest(
            userId: userId,
            request: .init(
                interestsToAdd: interestsToAdd,
                interestsToDelete: interestsToDelete,
                interestsToKeep: interestsToKeep
            )
        )
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func updateMyProfile(
        userId: String,
        profileImage: URL?,
        nickname: String,
        email: String,
        instagramId: String,
        intro: String
    ) -> Completable {
        let imageURL = profileImage?.absoluteString ?? ""
        let endPoint = PopPoolAPIEndPoint.user_updateMyProfile(
            userId: userId,
            request: .init(
                profileImage: imageURL,
                nickname: nickname,
                email: email,
                instagramId: instagramId,
                intro: intro
            )
        )
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func updateMyTailoredInfo(
        userId: String,
        gender: String,
        age: Int32
    ) -> Completable {
        let endPoint = PopPoolAPIEndPoint.user_updateMyTailoredInfo(userId: userId, request: .init(gender: gender, age: age))
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
}

