//
//  GetHomeInfoResponse.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation

struct GetHomeInfoResponse: Decodable {
    var nickname: String?
    var customPopUpStoreList: [HomePopUp]?
    var customPopUpStoreTotalPages: Int32?
    var customPopUpStoreTotalElements: Int64?
    var popularPopUpStoreList: [HomePopUp]?
    var popularPopUpStoreTotalPages: Int32?
    var popularPopUpStoreTotalElements: Int64?
    var newPopUpStoreList: [HomePopUp]?
    var newPopUpStoreTotalPages: Int32?
    var newPopUpStoreTotalElements: Int64?
    var loginYn: Bool?
}
