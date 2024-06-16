//
//  FetchKeychainUsecaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/15/24.
//

import Foundation
import RxSwift

/// 키체인에 저장된 데이터를 가져오는 usecase입니다
/// token을 호출하는 메서드를 실행합니다
final class FetchKeychainUseCaseImpl: FetchKeychainUseCase {
    var keychainRepository: KeyChainRepository
    
    init(keyChainRepository: KeyChainRepository) {
        self.keychainRepository = keyChainRepository
    }
    
    func fetchJwtToken(key: String) -> Single<String> {
        return keychainRepository.fetchSavedToken(id: key)
    }
}
