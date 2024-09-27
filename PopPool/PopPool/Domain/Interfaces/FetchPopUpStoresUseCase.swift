//
//  FetchPopUpStoresUseCase.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift

protocol FetchPopUpStoresUseCase {
    func execute() -> Observable<[MapPopUpStore]>
}

final class FetchPopUpStoresUseCaseImpl: FetchPopUpStoresUseCase {
    private let repository: MapRepository

    init(repository: MapRepository) {
        self.repository = repository
    }

    func execute() -> Observable<[MapPopUpStore]> {
        return repository.fetchPopUpStores()
    }
    private func handleResponse(response: GetViewBoundPopUpStoreListResponse) -> [MapPopUpStore] {
        return response.popUpStoreList.map { $0.toDomain() }
    }

}
