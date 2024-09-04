//
//  NoticeRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

import RxSwift

protocol NoticeRepository {
    
     /// 공지사항의 상세 정보를 조회하는 메서드입니다.
     ///
     /// - Parameters:
     ///   - noticeId: 조회할 공지사항의 고유 ID입니다.
     /// - Returns: 조회된 공지사항의 상세 정보를 담고 있는 `Observable<GetNoticeDetailResponse>` 객체를 반환합니다.
     func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse>
     
     /// 공지사항 목록을 조회하는 메서드입니다.
     ///
     /// - Returns: 조회된 공지사항 목록을 담고 있는 `Observable<GetNoticeListResponse>` 객체를 반환합니다.
     func fetchNoticeList() -> Observable<GetNoticeListResponse>
}
