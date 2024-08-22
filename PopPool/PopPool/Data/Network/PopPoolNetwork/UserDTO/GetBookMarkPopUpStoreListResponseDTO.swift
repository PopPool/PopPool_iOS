//
//  GetBookMarkPopUpStoreListResponseDTO.swift
//  PopPool
//
//  Created by Porori on 8/20/24.
//

import Foundation

struct GetBookMarkPopUpStoreListResponseDTO: Decodable, PageableResponse {
    var popUpInfoList: [PopUpInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}

extension GetBookMarkPopUpStoreListResponseDTO {
    func toDomain() -> GetBookMarkPopUpStoreListResponse {
        return GetBookMarkPopUpStoreListResponse(
            popUpInfoList: popUpInfoList.map({ $0.toDomain() }),
            totalPages: totalPages,
            totalElements: totalElements
        )
    }
}
