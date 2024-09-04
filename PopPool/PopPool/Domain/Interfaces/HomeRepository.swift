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
        userId: String,
        page: Int32,
        size: Int32,
        sort: [String]?
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchPopular(
        userId: String
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchNew(
        userId: String
    ) -> Observable<GetHomeInfoResponse>
    
    func fetchRecommended(
        userId: String
    ) -> Observable<GetHomeInfoResponse>
}
