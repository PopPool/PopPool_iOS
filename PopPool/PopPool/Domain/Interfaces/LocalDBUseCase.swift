//
//  LocalDBUsecase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

protocol LocalSaveUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에 값을 저장합니다.
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - value: DB에 저장하는 데이터
    ///   - to: 로컬 DB
    /// - Returns: 반환하는 값은 없음
    func save(key: String, value: String, to: String) -> Completable
}

protocol LocalFetchUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에서 값을 가져옵니다
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - from: 로컬 DB
    /// - Returns: 로컬 DB에서 지정된 키의 값을 반환합니다
    func fetch(key: String, from: String) -> Single<String>
}

protocol LocalDeleteUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에서 값을 삭제합니다
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - from: 로컬 DB
    /// - Returns: 반환하는 값 없음
    func delete(key: String, from: String) -> Completable
}
