//
//  NoticeRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

import RxSwift

protocol NoticeRepository {
    
    /// 공지사항을 등록하는 메서드입니다.
     ///
     /// - Parameters:
     ///   - title: 공지사항의 제목입니다.
     ///   - content: 공지사항의 내용입니다.
     /// - Returns: 작업의 성공 또는 실패를 나타내는 `Completable` 객체를 반환합니다.
     func postNotice(title: String, content: String) -> Completable
     
     /// 공지사항의 상세 정보를 조회하는 메서드입니다.
     ///
     /// - Parameters:
     ///   - noticeId: 조회할 공지사항의 고유 ID입니다.
     /// - Returns: 조회된 공지사항의 상세 정보를 담고 있는 `Observable<GetNoticeDetailResponse>` 객체를 반환합니다.
     func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse>
     
     /// 공지사항을 수정하는 메서드입니다.
     ///
     /// - Parameters:
     ///   - noticeId: 수정할 공지사항의 고유 ID입니다.
     ///   - title: 수정된 공지사항의 제목입니다.
     ///   - content: 수정된 공지사항의 내용입니다.
     /// - Returns: 작업의 성공 또는 실패를 나타내는 `Completable` 객체를 반환합니다.
     func updateNotice(noticeId: Int64, title: String, content: String) -> Completable
     
     /// 공지사항을 삭제하는 메서드입니다.
     ///
     /// - Parameters:
     ///   - noticeId: 삭제할 공지사항의 고유 ID입니다.
     ///   - adminId: 삭제 작업을 수행하는 관리자의 ID입니다.
     /// - Returns: 작업의 성공 또는 실패를 나타내는 `Completable` 객체를 반환합니다.
     func deleteNotice(noticeId: Int64, adminId: String) -> Completable
     
     /// 공지사항 목록을 조회하는 메서드입니다.
     ///
     /// - Returns: 조회된 공지사항 목록을 담고 있는 `Observable<GetNoticeListResponse>` 객체를 반환합니다.
     func fetchNoticeList() -> Observable<GetNoticeListResponse>
}
