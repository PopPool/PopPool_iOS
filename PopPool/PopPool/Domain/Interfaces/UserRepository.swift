//
//  UserRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation
import RxSwift

protocol UserRepository {
    
    /// 마이페이지 정보를 가져옵니다.
    /// - Parameter userId: 유저 아이디
    /// - Returns: Observable<GetMyPageResponse>
    func fetchMyPage(
        userId: String
    ) -> Observable<GetMyPageResponse>
    
    /// 내가 쓴 댓글을 가져옵니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - page: 페이지 번호
    ///   - size: 페이지 크기
    ///   - sort: 정렬 기준
    /// - Returns: Observable<GetMyCommentResponse>
    func fetchMyComment(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?,
        commentType: CommentType
    ) -> Observable<GetMyCommentResponse>
    
    /// 회원탈퇴를 시도합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - surveyList: 탈퇴 설문조사 리스트
    /// - Returns: Completable
    func tryWithdraw(userId: String, surveyList: CheckedSurveyListRequestDTO) -> Completable
    
    /// 내가 최근에 본 팝업 스토어 리스트를 가져옵니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - page: 페이지 번호
    ///   - size: 페이지 크기
    ///   - sort: 정렬 기준
    /// - Returns: Observable<GetMyRecentViewPopUpStoreListResponse>
    func fetchMyRecentViewPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?
    ) -> Observable<GetMyRecentViewPopUpStoreListResponse>
    
    /// 유저를 차단합니다.
    /// - Parameters:
    ///   - blockerUserId: 차단한 유저 아이디
    ///   - blockedUserId: 차단된 유저 아이디
    /// - Returns: Completable
    func userBlock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable
    
    /// 차단된 유저 리스트를 가져옵니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - page: 페이지 번호
    ///   - size: 페이지 크기
    ///   - sort: 정렬 기준
    /// - Returns: Observable<GetBlockedUserListResponse>
    func fetchBlockedUserList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?
    ) -> Observable<GetBlockedUserListResponse>
    
    /// 로그아웃을 시도합니다.
    /// - Returns: Completable
    func logOut() -> Completable
    
    /// 유저 차단을 해제합니다.
    /// - Parameters:
    ///   - blockerUserId: 차단 해제한 유저 아이디
    ///   - blockedUserId: 차단 해제된 유저 아이디
    /// - Returns: Completable
    func userUnblock(
        blockerUserId: String,
        blockedUserId: String
    ) -> Completable
    
    /// 탈퇴 설문조사 리스트를 가져옵니다.
    /// - Returns: Observable<GetWithDrawlSurveyResponse>
    func fetchWithdrawlSurveryList() -> Observable<GetWithDrawlSurveyResponse>
    
    /// 유저 프로필을 가져옵니다.
    /// - Parameter userId: 유저 아이디
    /// - Returns: Observable<GetProfileResponse>
    func fetchProfile(userId: String) -> Observable<GetProfileResponse>
    
    /// 유저 관심사를 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - interestCategoriesToAdd: 추가할 관심사 ID 리스트
    ///   - interestCategoriesToDelete: 삭제할 관심사 ID 리스트
    ///   - interestCategoriesToKeep: 유지할 관심사 ID 리스트
    /// - Returns: Completable
    func updateMyInterest(
        userId: String,
        interestsToAdd: [Int64],
        interestsToDelete: [Int64],
        interestsToKeep: [Int64]
    ) -> Completable
    
    /// 유저 프로필을 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - profileImageURL: 프로필 이미지 URL
    ///   - nickname: 닉네임
    ///   - email: 이메일
    ///   - instagramId: 인스타그램 ID
    ///   - intro: 자기소개
    /// - Returns: Completable
    func updateMyProfile(
        userId: String,
        profileImage: URL?,
        nickname: String,
        email: String?,
        instagramId: String?,
        intro: String?
    ) -> Completable
    
    /// 유저 맞춤 정보를 업데이트합니다.
    /// - Parameters:
    ///   - userId: 유저 아이디
    ///   - gender: 성별
    ///   - age: 나이
    /// - Returns: Completable
    func updateMyTailoredInfo(
        userId: String,
        gender: String,
        age: Int32
    ) -> Completable
    
    func fetchBookMarkPopUpStoreList(
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?
    ) -> Observable<GetBookMarkPopUpStoreListResponse>
    
    func updateBookMarkPopUpStore(
        userId: String,
        popUpStoreId: Int64
    ) -> Completable
    
    func deleteBookMarkPopUpStore(
        userId: String,
        popUpStoreId: Int64
    ) -> Completable
}
