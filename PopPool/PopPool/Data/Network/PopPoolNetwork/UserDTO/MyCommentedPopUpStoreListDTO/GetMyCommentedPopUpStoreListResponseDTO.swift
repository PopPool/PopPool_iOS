//
//  GetMyCommentedPopUpStoreListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyCommentedPopUpStoreListResponseDTO: Decodable, PageableResponse {
    var popUpInfoList: [PopUpInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}

extension GetMyCommentedPopUpStoreListResponseDTO {
    func toDomain() -> GetMyCommentedPopUpStoreListResponse {
        return GetMyCommentedPopUpStoreListResponse(
            popUpInfoList: popUpInfoList.map({ $0.toDomain() }),
            totalPages: totalPages,
            totalElements: totalElements
        )
    }
}
