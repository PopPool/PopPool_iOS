//
//  PreSignedService.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/5/24.
//

import Foundation

import RxSwift
import RxCocoa

class PreSignedService {
    let provider: ProviderImpl = ProviderImpl()
    let tokenInterceptor = TokenInterceptor()
    
    func upload(request: PresignedURLRequestDTO) -> Observable<PreSignedURLResponseDTO>{
        let endPoint = PopPoolAPIEndPoint.presigned_upload(request: request)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
    
    func download(request: PresignedURLRequestDTO) -> Observable<PreSignedURLResponseDTO>{
        let endPoint = PopPoolAPIEndPoint.presigned_download(request: request)
        return provider.requestData(with: endPoint, interceptor: tokenInterceptor)
    }
}
