//
//  KeyChainServiceUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/17/24.
//

import Foundation
import RxSwift

final class KeyChainServiceUseCaseImpl: KeyChainServiceUseCase {
    var service: KeyChainService
    
    init(service: KeyChainService) {
        self.service = service
    }
    
    func fetchToken(type: TokenType) -> Single<String> {
        return service.fetchToken(type: type)
    }
    
    func saveToken(type: TokenType, value: String) -> Completable {
        return service.saveToken(type: type, value: value)
    }
    
    func deleteToken(type: TokenType) -> Completable {
        return service.deleteToken(type: type)
    }
}
