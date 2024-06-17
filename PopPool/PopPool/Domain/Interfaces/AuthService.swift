//
//  AuthService.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/17/24.
//

import Foundation
import RxSwift

protocol AuthService: Responsable, AnyObject {
    
    /// 사용자 자격 증명을 가져오는 함수
    /// - Returns: Response 형태의 사용자 자격 증명
    func fetchUserCredential() -> Observable<Response>
}
