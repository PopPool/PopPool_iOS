//
//  PageableResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

protocol PageableResponse {
    var totalPages: Int32 { get set }
    var totalElements: Int64 { get set }
}
