//
//  GetHomeInfoResponseDTO.swift
//  PopPool
//
//  Created by Porori on 8/21/24.
//

import Foundation

struct GetHomeInfoResponseDTO: Decodable {
    var nickname: String
    var customPopUpStoreList: [HomePopUpDTO]
    var customPopUpStoreTotalPages: Int32
    var customPopUpStoreTotalElements: Int64
    var popularPopUpStoreList: [HomePopUpDTO]
    var popularPopUpStoreTotalPages: Int32
    var popularPopUpStoreTotalElements: Int64
    var newPopUpStoreList: [HomePopUpDTO]
    var newPopUpStoreTotalPages: Int32
    var newPopUpStoreTotalElements: Int64
    var loginYn: Bool
}

extension GetHomeInfoResponseDTO {
    func toDomain() -> GetHomeInfoResponse {
        return .init(
            nickname: nickname,
            customPopUpStoreList: customPopUpStoreList.map { $0.toDomain() },
            customPopUpStoreTotalPages: customPopUpStoreTotalPages,
            customPopUpStoreTotalElements: customPopUpStoreTotalElements,
            popularPopUpStoreList: popularPopUpStoreList.map { $0.toDomain() },
            popularPopUpStoreTotalPages: popularPopUpStoreTotalPages,
            popularPopUpStoreTotalElements: popularPopUpStoreTotalElements,
            newPopUpStoreList: newPopUpStoreList.map { $0.toDomain() },
            newPopUpStoreTotalPages: newPopUpStoreTotalPages,
            newPopUpStoreTotalElements: newPopUpStoreTotalElements,
            loginYn: loginYn
        )
    }
}
