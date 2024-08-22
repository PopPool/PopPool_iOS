//
//  HomeUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation
import RxSwift

final class HomeUseCaseImpl: HomeUseCase {
        
    var repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func fetchHome(userId: String) -> Observable<GetHomeInfoResponse> {
        repository.fetchHome(userId: userId)
    }
    
    func fetchPopular(userId: String) -> Observable<GetHomeInfoResponse> {
        repository.fetchPopular(userId: userId)
    }
    
    func fetchNew(userId: String) -> Observable<GetHomeInfoResponse> {
        repository.fetchNew(userId: userId)
    }
    
    func fetchRecommended(userId: String) -> Observable<GetHomeInfoResponse> {
        repository.fetchRecommended(userId: userId)
    }
    
}
