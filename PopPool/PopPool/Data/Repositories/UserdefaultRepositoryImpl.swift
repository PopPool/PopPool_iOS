//
//  UserdefaultRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation
import RxSwift

// Userdefault를 활용한 Data Layer
final class UserdefaultRepositoryImpl: LocalDBRepository {
    
    /// Userdefault 데이터 저장 메서드
    /// - Parameters:
    ///   - key: 저장하는 데이터의 키 값 i.e) 유저 id 등
    ///   - value: 저장하는 데이터 값 i.e) access token 등
    ///   - to: 로컬 데이터베이스 타입 - DatabaseType
    /// - Returns: 별도 안내 없음
    func save(key: String, value: String) -> Completable {
        return Completable.create { complete in
            UserDefaults.standard.set(value, forKey: key)
            complete(.completed)
            return Disposables.create()
        }
    }
    
    /// Userdefault 데이터 발견 메서드
    /// - Parameters:
    ///   - key: 찾는 데이터의 키 값 i.e) 유저 id 등
    ///   - from: 로컬 데이터베이스 타입 - DatabaseType
    /// - Returns: 찾은 데이터 - String 타입
    func fetch(key: String, from: String) ->  Single<String> {
        return Single.create { complete in
            if let token = UserDefaults.standard.string(forKey: key) {
                complete(.success(token))
            }
            return Disposables.create()
        }
    }
    
    /// Userdefault 데이터 삭제 메서드
    /// - Parameters:
    ///   - key: 삭제하는 데이터의 키 값 i.e) 유저 id 등
    ///   - from: 로컬 데이터베이스 타입 - DatabaseType
    /// - Returns: 별도 안내 없음
    func delete(key: String, from: String) -> Completable {
        return Completable.create { complete in
            UserDefaults.standard.removeObject(forKey: key)
            return Disposables.create()
        }
    }
}
