//
//  UserdefaultRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

// Userdefault를 활용한 Data Layer
class UserdefaultRepositoryImpl: TokenRepository {
    
    func save(account: String, token: String) -> Completable {
        return Completable.create { complete in
            UserDefaults.standard.set(token, forKey: account)
            complete(.completed)
            return Disposables.create()
        }
    }
    
    func fetch(account: String) ->  Single<String> {
        print("")
        return Single.create { value in
            Disposables.create()
        }
    }
    
    func delete(account: String) -> Completable {
        return Completable.create { complete in
            return Disposables.create()
        }
    }
}
