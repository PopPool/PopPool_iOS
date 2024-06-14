//
//  Keychain.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation
import Security
import RxSwift

enum KeychainError: Error {
    case dataConversionError
    case unhandledError(status: OSStatus)
}

class KeyChainRepositoryImpl: KeyChainRepository {
    /// 키체인에 데이터를 저장하는 메서드입니다
    /// - Parameters:
    ///   - key: keychain에 데이터를 저장할 때 사용하는 키 값입니다.
    ///   임의로 지정을 할 수 있습니다
    ///   - value: keychain에 저장할 데이터 값을 받습니다.
    ///   사용자의 비밀번호 등이 될 수 있습니다
    /// - Returns: 저장의 경우 별도로 반환하는 값이 없어 Completable을 반환합니다.
    func save(key: String, value: String) -> RxSwift.Completable {
        return Completable.create { complete in
            guard let data = value.data(using: .utf8) else {
                complete(.error(KeychainError.dataConversionError))
                return Disposables.create()
            }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                complete(.completed)
            } else {
                complete(.error(KeychainError.unhandledError(status: status)))
            }
            return Disposables.create()
        }
    }
    
//    func fetch(key: String) -> RxSwift.Single<String?> {
//        print("가져옵니다")
//        return Single.create { data in
//            
//            data(.success())
//        }
//        print("데이터를 반환합니다.")
//    }
}
