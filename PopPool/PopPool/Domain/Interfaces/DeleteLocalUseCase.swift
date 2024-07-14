//
//  DeleteLocalUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import Foundation
import RxSwift

protocol DeleteLocalUseCase {
    var repository: LocalDBRepository { get set }
    
    /// 로컬 DB에서 값을 삭제합니다
    /// - Parameters:
    ///   - key: 계정 이름 ie) ID, accessKey 등
    ///   - from: 로컬 DB
    /// - Returns: 반환하는 값 없음
    func execute(key: String) -> Completable
}
