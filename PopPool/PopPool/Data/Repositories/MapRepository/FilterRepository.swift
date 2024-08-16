//
//  FilterRepository.swift
//  PopPool
//
//  Created by 김기현 on 8/15/24.
//

import RxSwift


class FilterRepository {
    private let remoteDataSource: RemoteDataSource

    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func addFilter(_ filter: Filter) -> Single<[Filter]> {
        return remoteDataSource.addFilter(filter)
    }

    func removeFilter(_ filter: Filter) -> Single<[Filter]> {
        return remoteDataSource.removeFilter(filter)
    }

    func resetFilters() -> Single<Void> {
        return remoteDataSource.resetFilters()
    }

    func applyFilters(_ filters: [Filter]) -> Completable {
        return remoteDataSource.applyFilters(filters)
    }
}

