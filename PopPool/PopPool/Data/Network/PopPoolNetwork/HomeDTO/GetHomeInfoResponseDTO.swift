//
//  GetHomeInfoResponseDTO.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation

struct GetHomeInfoResponseDTO: Decodable {
    var nickname: String
    var customPopUpStoreList: [PopUpStoreDTO]
    var customPopUpStoreTotalPages: Int32
    var customPopUpStoreTotalElements: Int64
    var popularPopUpStoreList: [PopUpStoreDTO]
    var popularPopUpStoreTotalPages: Int32
    var popularPopUpStoreTotalElements: Int64
    var newPopUpStoreList: [PopUpStoreDTO]
    var newPopUpStoreTotalPages: Int32
    var newPopUpStoreTotalElements: Int64
    var login: Bool
}

extension GetHomeInfoResponseDTO {
    func toDomain() -> GetHomeInfoResponse {
        return .init(
            nickname: nickname,
            curatedPopUpStoreList: customPopUpStoreList,
            curatedPopUpStoreTotalPages: customPopUpStoreTotalPages,
            curatedPopUpStoreTotalElements: customPopUpStoreTotalElements,
            popularPopUpStoreList: popularPopUpStoreList,
            popularPopUpStoreTotalPages: popularPopUpStoreTotalPages,
            popularPopUpStoreTotalElements: popularPopUpStoreTotalElements,
            newPopUpStoreList: newPopUpStoreList,
            newPopUpStoreTotalPages: newPopUpStoreTotalPages,
            newPopUpStoreTotalElements: newPopUpStoreTotalElements,
            login: login
        )
    }
}
