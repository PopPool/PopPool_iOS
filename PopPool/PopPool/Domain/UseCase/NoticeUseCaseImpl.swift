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
    
    func postNotice(title: String, content: String) -> Completable {
        return repository.postNotice(title: title, content: content)
    }
    
    func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse> {
        return repository.fetchNoticeDetail(noticeId: noticeId)
    }
    
    func updateNotice(noticeId: Int64, title: String, content: String) -> Completable {
        return repository.updateNotice(noticeId: noticeId, title: title, content: content)
    }
    
    func deleteNotice(noticeId: Int64, adminId: String) -> Completable {
        return repository.deleteNotice(noticeId: noticeId, adminId: adminId)
    }
    
    func fetchNoticeList() -> Observable<GetNoticeListResponse> {
        return repository.fetchNoticeList()
    }
}
