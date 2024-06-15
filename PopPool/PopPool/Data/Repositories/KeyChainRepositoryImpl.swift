//
//  KeyChainRepositoryImpl.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation
import Security
import RxSwift

// 추후 폴더링 변경
enum KeychainError: Error {
    case dataConversionError(String)
    case duplicateItem(String)
    case unhandledError(status: OSStatus)
    case noTokenFound(String)
    case noData(String)
}

final class KeyChainRepositoryImpl: KeyChainRepository {
    /// 키체인에 데이터를 저장하는 메서드입니다
    /// - Parameters:
    ///   - key: keychain에 데이터를 저장할 때 사용하는 키 값입니다.
    ///   임의로 지정을 할 수 있습니다
    ///   - value: keychain에 저장할 데이터 값을 받습니다.
    ///   사용자의 비밀번호 등이 될 수 있습니다
    /// - Returns: 저장의 경우 별도로 반환하는 값이 없어 Completable을 반환합니다.
    func save(id: String, key: String) -> Completable {
        return Completable.create { complete in
            guard let storedToken = key.data(using: .utf8) else {
                complete(.error(KeychainError.dataConversionError("데이터를 변환하는데 실패했습니다.")))
                return Disposables.create()
            }
            
            // keychain에 데이터를 저장하기 위해 query Dictionary를 생성합니다
            // 지정된 query 값에 아이디와 token을 저장합니다
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: id,
                kSecValueData as String: storedToken
            ]
            
            // 정리한 query 값을 Dictionary에 넣습니다
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                complete(.completed)
            } else {
                complete(.error(KeychainError.unhandledError(status: status)))
            }
            return Disposables.create()
        }
    }
    
    /// 저장된 token 값을 호출하는 메서드입니다
    /// - Parameter key: 토큰 값을 query하기 위한 유저 id값을 받습니다
    /// - Returns: 해당 id의 토큰을 반환합니다
    func fetchSavedToken(id: String) -> Single<String> {
        return Single.create { singleData in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: id,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            // keyChain 내부를 검색할 객체를 활용합니다
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            // Keychain 내부에 검색한 데이터 상태(존재 여부)를 확인합니다
            if status == errSecItemNotFound {
                singleData(.failure(KeychainError.noTokenFound("저장된 키 값이 없습니다.")))
            } else if status != errSecSuccess {
                singleData(.failure(KeychainError.unhandledError(status: status)))
            }
            
            // 데이터가 있다는 가정하에 Data로 변형을 합니다
            guard let data = item as? Data else {
                singleData(.failure(KeychainError.noData("해당 데이터 값이 없습니다.")))
                return Disposables.create()
            }
            
            // 변형된 Data를 String 타입으로 변환하여 반환합니다
            guard let unwrappedJwtToken = String(data: data, encoding: .utf8) else {
                singleData(.failure(KeychainError.dataConversionError("String으로 변환을 실패했습니다.")))
                return Disposables.create()
            }
            
            singleData(.success(unwrappedJwtToken))
            return Disposables.create()
        }
    }
    
    /// 토큰 데이터를 삭제합니다
    /// - Parameter id: 유저의 id값을 파라미터로 받습니다
    /// - Returns: 삭제 이후 반환되는 데이터는 없습니다
    func delete(id: String) -> Completable {
        return Completable.create { complete in
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: id
            ]
            
            // Keychain 데이터 상태를 확인합니다
            let status = SecItemDelete(query as CFDictionary)
            
            if status == errSecSuccess {
                print("데이터를 삭제했습니다.")
                // 알람 안내 추후 적용 필요
                complete(.completed)
            } else {
                complete(.error(KeychainError.unhandledError(status: status)))
            }
            
            return Disposables.create()
        }
    }
}
