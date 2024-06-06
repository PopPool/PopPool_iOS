//
//  AuthService.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/5/24.
//

import Foundation
import RxSwift

protocol AuthService {

    var type: AuthType { get set }
    func tryFetchToken() -> Observable<String>
    func tryFetchUserID() -> Observable<Int>
}

enum AuthType {
    case kakao
    case apple
}
