//
//  FetchFromKeyChainUseCase.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/16/24.
//

import Foundation
import RxSwift

/// 키체인에서 데이터를 가져오는 유스케이스를 정의하는 프로토콜입니다.
protocol FetchFromKeyChainUseCase {
    
    /// 키체인 저장소를 관리하는 레포지토리
    var repository: KeyChainRepository { get set }
    
    /// 키체인에서 값을 가져옵니다.
    /// - Parameters:
    ///   - service: 키체인 서비스 이름을 나타내는 열거형
    ///   - account: 키체인 계정 이름을 나타내는 열거형
    /// - Returns: 가져온 값을 담은 Single
    func execute(service: KeyChainService, account: KeyChainAccount) -> Single<String>
}
