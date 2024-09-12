//
//  SearchPopUpStoresUseCaseImpl.swift
//  PopPool
//
//  Created by 김기현 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa

/// 저장소를 통해 팝업 스토어 데이터를 가져옵니다.
class SearchPopUpStoresUseCaseImpl: SearchPopUpStoresUseCase {
    private let repository: PopUpStoreRepository

    /// UseCase를 초기화합니다.
    /// - Parameter repository: `PopUpStoreRepository`의 구현체
    init(repository: PopUpStoreRepository) {
        self.repository = repository
    }

    /// 주어진 검색어를 기반으로 팝업 스토어 목록을 가져옵니다.
    func execute(query: String) -> Observable<[PopUpStore]> {
        return repository.searchPopUpStores(query: query)
    }
}
