//
//  KeyChainServiceUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/17/24.
//

import Foundation
import RxSwift

protocol KeyChainServiceUseCase {
    
    var service: KeyChainService { get set }
    
    /// 토큰을 가져오는 메서드
    ///
    /// - Parameter type: 가져올 토큰의 종류
    /// - Returns: 토큰 문자열을 포함한 Single
    func fetchToken(type: TokenType) -> Single<String>
    
    /// 토큰을 저장하는 메서드
    ///
    /// - Parameters:
    ///   - type: 저장할 토큰의 종류
    ///   - value: 저장할 토큰 값
    /// - Returns: 저장 작업의 결과를 나타내는 Completable
    func saveToken(type: TokenType, value: String) -> Completable
    
    /// 토큰을 삭제하는 메서드
    ///
    /// - Parameter type: 삭제할 토큰의 종류
    /// - Returns: 삭제 작업의 결과를 나타내는 Completable
    func deleteToken(type: TokenType) -> Completable
}
