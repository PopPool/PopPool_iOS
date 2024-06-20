//
//  LocalDBUsecase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

protocol LocalSaveUsecase {
    var repository: LocalDBRepository { get set }
    
    func save(key: String, value: String, to: String) -> Completable
}

protocol LocalFetchUsecase {
    var repository: LocalDBRepository { get set }
    
    func fetch(key: String, from: String) -> Single<String>
}

protocol LocalDeleteUsecase {
    var repository: LocalDBRepository { get set }
    
    func delete(key: String, from: String) -> Completable
}
