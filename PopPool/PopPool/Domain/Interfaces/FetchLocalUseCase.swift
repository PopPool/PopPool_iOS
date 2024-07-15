//
//  FetchLocalUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import Foundation
import RxSwift

protocol FetchLocalUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에서 값을 가져옵니다
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - from: 로컬 DB
    /// - Returns: 로컬 DB에서 지정된 키의 값을 반환합니다`_40px`
    func execute(key: String) -> Single<String>
}
