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
    
    func fetchNoticeDetail(noticeId: Int64) -> Observable<GetNoticeDetailResponse> {
        let endPoint = PopPoolAPIEndPoint.notice_fetchNoticeDetail(id: noticeId)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map{ $0.toDomain() }
    }
    
    func fetchNoticeList() -> Observable<GetNoticeListResponse> {
        let endPoint = PopPoolAPIEndPoint.notice_fetchNoticeList()
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor).map{ $0.toDomain() }
    }
}
