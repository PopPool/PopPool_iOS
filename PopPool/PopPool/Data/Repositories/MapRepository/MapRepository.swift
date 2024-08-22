//
//  MapRepository.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift

protocol MapRepository {
    func fetchPopUpStores() -> Observable<[PopUpStore]>
}
