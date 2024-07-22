//
//  PageableDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct PageableDTO: Encodable {
    var page: Int32
    var size: Int32
    var sort: [String]
}
