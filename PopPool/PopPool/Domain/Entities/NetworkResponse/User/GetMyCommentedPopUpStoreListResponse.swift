//
//  GetMyCommentedPopUpStoreListResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyCommentedPopUpStoreListResponse {
    var myCommentList: [PopUpInfo]
    var totalPages: Int32
    var totalElements: Int64
}
