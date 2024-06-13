//
//  Keychain.swift
//  PopPool
//
//  Created by Porori on 6/13/24.
//

import Foundation
import Security

class KeychainManager {
    
    enum KeyChainError: Error {
        case noPassword
        case duplicates
        // high level of result value in 32 bit data
        case unknown(status: OSStatus)
    }
    
    static func save(service: String, account: String, password: Data) throws {
        // service, account, class, data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else { throw KeyChainError.duplicates }
        guard status == errSecSuccess else { throw KeyChainError.unknown(status: status) }
        print("저장되었습니다.")
    }
    
    static func get() {
        // service, account, class, return data, matchlimit
    }
}
