//
//  NoticeUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

import RxSwift

final class NoticeUseCaseImpl: NoticeUseCase {
    var repository: NoticeRepository
    
    init(repository: NoticeRepository) {
        self.repository = repository
    }
    
    func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse> {
        return repository.fetchNoticeDetail(noticeId: noticeId)
    }
    
    func fetchNoticeList() -> Observable<GetNoticeListResponse> {
        return repository.fetchNoticeList()
    }
}
