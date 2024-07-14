//
//  LocalSaveUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

protocol SaveLocalUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에 값을 저장합니다.
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - value: DB에 저장하는 데이터
    ///   - to: 로컬 DB
    /// - Returns: 반환하는 값은 없음
    func execute(key: String, value: String) -> Completable
}

final class SaveLocalUseCaseImpl: SaveLocalUseCase {

    var repository: LocalDBRepository
    
    init(repository: LocalDBRepository) {
        self.repository = repository
    }
    
    func execute(key: String, value: String) -> Completable {
        repository.save(key: key, value: value)
    }
}
