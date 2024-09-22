//
//  GetAdminPopUpListRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/9/24.
//

import Foundation

struct GetAdminPopUpListRequestDTO: Encodable, Pageable {
    var query: String?
    var page: Int32
    var size: Int32
    var sort: [String]?
}
