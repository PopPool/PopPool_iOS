//
//  GetMyRecentViewPopUpStoreListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyRecentViewPopUpStoreListResponseDTO: Decodable, PageableResponse {
    var popUpInfoList: [PopUpInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}

extension GetMyRecentViewPopUpStoreListResponseDTO {
    func toDomain() -> GetMyRecentViewPopUpStoreListResponse {
        return GetMyRecentViewPopUpStoreListResponse (
            popUpInfoList: popUpInfoList.map({ $0.toDomain() }),
            totalPages: totalPages,
            totalElements: totalElements
        )
    }
}
