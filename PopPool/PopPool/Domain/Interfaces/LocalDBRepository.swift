//
//  LocalDBRepository.swift
//  PopPool
//
//  Created by Porori on 6/14/24.
//

import Foundation
import RxSwift

/// 키체인에 Create, Fetch, Delete를 수행하는 저장소
protocol LocalDBRepository {
    
    /// DB에 값을 저장합니다.
    /// - Parameters:
    ///   - key: 계정 이름
    ///   - value: 저장할 값
    /// - Returns: 작업의 성공 또는 실패를 알리는 Completable
    func save(key: String, value: String) -> Completable
    
    /// DB에 값을 가져옵니다.
    /// - Parameters:
    ///   - key: 계정 이름
    /// - Returns: 가져온 값을 담은 Single
    func fetch(key: String) -> Single<String>
    
    /// DB에 값을 삭제합니다.
    /// - Parameters:
    ///   - key: 계정 이름
    /// - Returns: 작업의 성공 또는 실패를 알리는 Completable
    func delete(key: String) -> Completable
}
