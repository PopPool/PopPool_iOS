//
//  FetchSocialCredentialUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/8/24.
//

import Foundation

import RxSwift

final class FetchSocialCredentialUseCaseImpl: FetchSocialCredentialUseCase {
    
    var service: any AuthService
    
    init(service: any AuthService) {
        self.service = service
    }

    func execute() -> Observable<Encodable> {
        return service.fetchUserCredential()
    }
}
