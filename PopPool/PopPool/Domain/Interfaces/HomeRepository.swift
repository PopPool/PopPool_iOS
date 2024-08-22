//
//  HomeRepository.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation
import RxSwift

protocol HomeRepository {
    
    func fetchHome(
        userId: String
    ) -> Observable<GetHomeInfoResponse>
}
