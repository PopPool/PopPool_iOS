//
//  GetBookMarkPopUpStoreListRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/28/24.
//

import Foundation

struct GetBookMarkPopUpStoreListRequestDTO: Encodable, Pageable {
    var page: Int32
    var size: Int32
    var sort: [String]?
}
