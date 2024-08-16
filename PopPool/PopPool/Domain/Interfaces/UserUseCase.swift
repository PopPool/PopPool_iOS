//
//  UserUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/3/24.
//

import Foundation
import RxSwift

protocol UserUseCase {
    
    var repository: UserRepository { get set }
    
    func fetchMyPage(
        userId: String
    ) -> Observable<GetMyPageResponse>
    
    func fetchMyComment(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentResponse>
    
    func tryWithdraw(
        userId: String,
        surveyList: [Survey]
    ) -> Completable
    
    func fetchMyCommentedPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyCommentedPopUpStoreListResponse>
    
    func fetchMyRecentViewPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetMyRecentViewPopUpStoreListResponse>
    
    func userBlock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable
    
    func fetchBlockedUserList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]
    ) -> Observable<GetBlockedUserListResponse>
    
    func logOut() -> Completable
    
    func userUnblock(blockerUserId: String, blockedUserId: String) -> Completable
    
    func fetchWithdrawlSurveryList() -> Observable<GetWithDrawlSurveyResponse>
    
    func fetchProfile(userId: String) -> Observable<GetProfileResponse>
    
    func updateMyInterest(
        userId: String,
        interestsToAdd: [Int64],
        interestsToDelete: [Int64],
        interestsToKeep: [Int64]
    ) -> Completable
    
    func updateMyProfile(
        userId: String,
        profileImage: URL?,
        nickname: String,
        email: String,
        instagramId: String,
        intro: String
    ) -> Completable
    
    func updateMyTailoredInfo(userId: String, gender: String, age: Int32) -> Completable
}
