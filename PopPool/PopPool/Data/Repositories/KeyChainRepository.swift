//
//  KeyChainRepository.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

protocol KeyChainRepository {
    func save(key: String, value: String) -> Completable
//    func fetch(key: String) -> Single<String?>
//    func remove()
}
