//
//  StoresService.swift
//  PopPool
//
//  Created by 김기현 on 8/8/24.
//

import Foundation
import RxSwift

class StoresService: StoresServiceProtocol {
    func getAllStores() -> Observable<[PopUpStore]> {
        // 실제 API 호출 또는 데이터베이스 조회 구현
        return .just([])
    }

    func searchStores(query: String) -> Observable<[PopUpStore]> {
        // 실제 검색 로직 구현
        return .just([])
    }
}
