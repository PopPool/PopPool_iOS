//
//  AdminRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation
import RxSwift

final class AdminRepositoryImpl: AdminRepository {
    
    private let provider = ProviderImpl()
    private let tokenInterceptor = TokenInterceptor()
    private let requestTokenInterceptor = RequestTokenInterceptor()
    
    func updateNotice(noticeId: Int64, title: String, content: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.admin_updateNotice(id: noticeId, title: title, content: content)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func postNotice(title: String, content: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.admin_postNotice(title: title, content: content)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func deleteNotice(noticeId: Int64, adminId: String) -> Completable {
        let endPoint = PopPoolAPIEndPoint.admin_deleteNotice(id: noticeId, adminId: adminId)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    // MARK: - PopUp API

    func getPopUpDetail(popUpID: Int64) -> Observable<GetAdminPopUpStoreDetailResponseDTO>{
        let endPoint = PopPoolAPIEndPoint.admin_getDetailPopUp(popUpStoreId: popUpID)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func getPopUpList(request: GetAdminPopUpListRequestDTO) -> Observable<GetAdminPopUpStoreListResponseDTO>{
        let endPoint = PopPoolAPIEndPoint.admin_getPopUpList(request: request)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func updatePopUp(updatePopUp: UpdatePopUpStoreRequestDTO) -> Completable {
        let endPoint = PopPoolAPIEndPoint.admin_updatePopUp(updatePopUp: updatePopUp)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    
    func postPopUpStore(createPopUp: CreatePopUpStoreRequestDTO) -> Completable{
        let endPoint = PopPoolAPIEndPoint.admin_postPopUp(postPopUp: createPopUp)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
    func deletePopUp(popUpID: Int64) -> Completable{
        let endPoint = PopPoolAPIEndPoint.admin_getDetailPopUp(popUpStoreId: popUpID)
        return provider.request(with: endPoint, interceptor: requestTokenInterceptor)
    }
}
