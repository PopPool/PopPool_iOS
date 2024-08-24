//
//  NoticeRepositoryImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

import RxSwift
import RxCocoa

final class NoticeRepositoryImpl: NoticeRepository {
    
    private let provider = ProviderImpl()
    private let tokenInterceptor = TokenInterceptor()
    private let requestTokenInterceptor = RequestTokenInterceptor()
    
    func postNotice(title: String, content: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.notice_postNotice(title: title, content: content)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse> {
        let endPoint = PopPoolAPIEndPoint.notice_fetchNoticeDetail(id: noticeId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map{ $0.toDomain() }
    }
    
    func updateNotice(noticeId: Int64, title: String, content: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.notice_updateNotice(id: noticeId, title: title, content: content)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func deleteNotice(noticeId: Int64, adminId: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.notice_deleteNotice(id: noticeId, adminId: adminId)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func fetchNoticeList() -> Observable<GetNoticeListResponse> {
        let endPoint = PopPoolAPIEndPoint.notice_fetchNoticeList()
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map{ $0.toDomain() }
    }
}
