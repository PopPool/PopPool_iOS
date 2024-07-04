//
//  SignUpRepository.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation
import RxSwift

protocol SignUpRepository{
    
    /// 닉네임 중복 여부를 확인하는 메서드
    /// - Parameters:
    ///   - nickName: 확인할 닉네임
    ///   - credential: 인증 정보
    /// - Returns: 닉네임이 중복되었는지 여부를 나타내는 Observable<Bool>
    func checkNickName(nickName: String, credential: MyAuthenticationCredential) -> Observable<Bool>
    
    /// 관심사 리스트를 가져오는 메서드
    /// - Parameter credential: 인증 정보
    /// - Returns: 관심사 리스트를 나타내는 Observable<[Interest]>
    func fetchInterestList(credential: MyAuthenticationCredential) -> Observable<[Interest]>
}
