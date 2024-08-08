//
//  UserUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/3/24.
//

import Foundation
import RxSwift

final class UserUseCaseImpl: UserUseCase {
    
    var repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func fetchMyPage(
        userId: String
    ) -> Observable<GetMyPageResponse> {
        return repository
            .fetchMyPage(userId: userId)
    }
    
    func fetchMyComment(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentResponse> {
        return repository
            .fetchMyComment(
                userId: userId,
                page: page,
                size: size,
                sort: sort
            )
    }
    
    func tryWithdraw(
        userId: String,
        surveyList: [Survey]
    ) -> Completable {
        return repository
            .tryWithdraw(
                userId: userId,
                surveyList: surveyList
            )
    }
    
    func fetchMyCommentedPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentedPopUpStoreListResponse> {
        return repository
            .fetchMyCommentedPopUpStoreList(
                userId: userId,
                page: page,
                size: size,
                sort: sort
            )
    }
    
    func fetchMyRecentViewPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyRecentViewPopUpStoreListResponse> {
        return repository
            .fetchMyRecentViewPopUpStoreList(
                userId: userId,
                page: page,
                size: size,
                sort: sort
            )
    }
    
    func userBlock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable {
        return repository
            .userBlock(
                blockerUserId: blockerUserId,
                blockedUserId: blockedUserId
            )
    }
    
    func fetchBlockedUserList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetBlockedUserListResponse> {
        return repository
            .fetchBlockedUserList(
                userId: userId,
                page: page,
                size: size,
                sort: sort
            )
    }
    
    func logOut() -> Completable {
        return repository
            .logOut()
    }
    
    func userUnblock(blockerUserId: String, blockedUserId: String) -> Completable {
        return repository.userUnblock(blockerUserId: blockerUserId, blockedUserId: blockedUserId)
    }
    
    func fetchWithdrawlSurveryList() -> Observable<GetWithDrawlSurveyResponse> {
        return repository
            .fetchWithdrawlSurveryList()
    }
    
    func fetchProfile(userId: String) -> Observable<GetProfileResponse> {
        return repository
            .fetchProfile(userId: userId)
    }
    
    func updateMyInterest(
        userId: String,
        interestsToAdd: [Int64],
        interestsToDelete: [Int64],
        interestsToKeep: [Int64]
    ) -> Completable {
        return repository
            .updateMyInterest(
                userId: userId,
                interestsToAdd: interestsToAdd,
                interestsToDelete: interestsToDelete,
                interestsToKeep: interestsToKeep
            )
    }
    
    func updateMyProfile(
        userId: String,
        profileImage: URL?,
        nickname: String,
        email: String,
        instagramId: String,
        intro: String
    ) -> Completable {
        return repository
            .updateMyProfile(
                userId: userId,
                profileImage: profileImage,
                nickname: nickname,
                email: email,
                instagramId: instagramId,
                intro: intro
            )
    }
    
    func updateMyTailoredInfo(userId: String, gender: String, age: Int32) -> Completable {
        return repository
            .updateMyTailoredInfo(userId: userId, gender: gender, age: age)
    }
}
