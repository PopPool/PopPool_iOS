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
