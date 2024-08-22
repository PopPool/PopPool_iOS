//
//  GetNoticeDetailResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/18/24.
//

import Foundation

struct GetNoticeDetailResponseDTO: Decodable {
    var id: Int64
    var title: String
    var content: String
    var createDateTime: String
}
