//
//  SaveTokenUsecase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

protocol SaveTokenUsecase {
    func save(account: String, token: String) -> Completable
    func fetch(account: String) -> Single<String>
    func delete(account: String) -> Completable
}
