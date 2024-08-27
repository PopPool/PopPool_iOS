//
//  GetAdminPopUpStoreListResponse.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct GetAdminPopUpStoreListResponseDTO: Decodable {
    let popUpStoreList: [PopUpStoreDTO]
    let totalPages: Int32
    let totalElements: Int64
}

extension GetAdminPopUpStoreListResponseDTO {
    func toDomain() -> GetAdminPopUpStoreListResponse {
        return .init(popUpStoreList: popUpStoreList.map { $0.toDomain() },
                     totalPages: totalPages,
                     totalElements: totalElements
        )
    }
}
