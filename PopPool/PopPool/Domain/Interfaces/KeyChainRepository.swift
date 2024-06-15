//
//  KeyChainRepository.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

/// 키체인에서 담당할 역할들입니다
protocol KeyChainRepository {
    func save(id: String, key: String) -> Completable
    func fetchSavedToken(id: String) -> Single<String>
    func delete(id: String) -> Completable
}
