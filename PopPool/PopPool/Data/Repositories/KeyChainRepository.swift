//
//  KeyChainRepository.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

/// 키체인에서 담당할 역할들입니다
/// 현재 추가 구현 중에 있습니다
protocol KeyChainRepository {
    func save(key: String, value: String) -> Completable
//    func fetch(key: String) -> Single<String?>
//    func remove()
}
