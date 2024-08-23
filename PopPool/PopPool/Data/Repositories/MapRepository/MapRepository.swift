//
//  MapRepository.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift

protocol MapRepository {
    func fetchPopUpStores(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, category: String?) -> Observable<[PopUpStore]>
}
