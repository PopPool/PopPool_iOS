//
//  MapRepositoryImpl.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift

final class MapRepositoryImpl: MapRepository {
    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func fetchPopUpStores() -> Observable<[MapPopUpStore]> {
        let endpoint = PopPoolAPIEndPoint.map_fetchPopUpStores()
        return provider.requestData(with: endpoint)
            .map { $0.map { $0.toDomain() } }
    }
}
