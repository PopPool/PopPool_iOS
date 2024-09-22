//
//  FetchPopUpStoresUseCase.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift

protocol FetchPopUpStoresUseCase {
    func execute() -> Observable<[PopUpStore]>
}

final class FetchPopUpStoresUseCaseImpl: FetchPopUpStoresUseCase {
    private let repository: MapRepository

    init(repository: MapRepository) {
        self.repository = repository
    }

    func execute() -> Observable<[PopUpStore]> {
        return repository.fetchPopUpStores()
    }
    private func handleResponse(response: GetViewBoundPopUpStoreListResponse) -> [PopUpStore] {
        return response.popUpStoreList.map { $0.toDomain() }
    }

}
