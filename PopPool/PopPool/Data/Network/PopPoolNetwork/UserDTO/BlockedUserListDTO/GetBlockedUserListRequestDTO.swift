//
//  GetBlockedUserListRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetBlockedUserListRequestDTO: Encodable, Pageable {
    var userId: String
    var page: Int32
    var size: Int32
    var sort: [String]?
}
