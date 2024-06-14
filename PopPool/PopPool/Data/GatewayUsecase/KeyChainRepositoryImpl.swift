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
