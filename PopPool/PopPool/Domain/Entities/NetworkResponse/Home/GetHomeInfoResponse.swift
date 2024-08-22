//
//  GetHomeInfoResponse.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation

// customPopUpStoreList를 Curated로 변경
struct GetHomeInfoResponse: Decodable {
    var nickname: String
    var curatedPopUpStoreList: [PopUpStoreDTO]
    var curatedPopUpStoreTotalPages: Int32
    var curatedPopUpStoreTotalElements: Int64
    var popularPopUpStoreList: [PopUpStoreDTO]
    var popularPopUpStoreTotalPages: Int32
    var popularPopUpStoreTotalElements: Int64
    var newPopUpStoreList: [PopUpStoreDTO]
    var newPopUpStoreTotalPages: Int32
    var newPopUpStoreTotalElements: Int64
    var login: Bool
}
