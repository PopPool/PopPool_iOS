//
//  GetMyCommentedPopUpStoreListRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyCommentedPopUpStoreListRequestDTO: Encodable, Pageable {
    var page: Int32
    var size: Int32
    var sort: [String]?
}
