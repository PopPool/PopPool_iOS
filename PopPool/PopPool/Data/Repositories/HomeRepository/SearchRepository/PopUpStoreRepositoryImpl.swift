//
//  PopUpStoreRepositoryImpl.swift
//  PopPool
//
//  Created by 김기현 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

/// `StoresService`를 사용하여 API로부터 팝업 스토어 데이터를 가져옵니다.
class PopUpStoreRepositoryImpl: PopUpStoreRepository {
    private let service: StoresServiceProtocol

    /// Repository를 초기화합니다.
    /// - Parameter service: `StoresServiceProtocol`의 구현체
    init(service: StoresServiceProtocol) {
        self.service = service
    }

    /// 주어진 검색어를 기반으로 팝업 스토어 목록을 가져옵니다.
    func searchPopUpStores(query: String) -> Observable<[PopUpStore]> {
        return service.searchStores(query: query)
    }
}
