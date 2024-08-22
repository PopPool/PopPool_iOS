//
//  HomeUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation
import RxSwift

final class FetchHomeUseCaseImpl: FetchHomeUseCase {
        
    var repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func execute(userId: String) -> Observable<GetHomeInfoResponse> {
        repository.fetchHome(userId: userId)
    }    
}
