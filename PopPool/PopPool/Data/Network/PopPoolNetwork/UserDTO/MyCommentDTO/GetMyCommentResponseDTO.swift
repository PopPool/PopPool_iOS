//
//  GetMyCommentResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct GetMyCommentResponseDTO: Decodable, PageableResponse {
    var myCommentList: [MyCommentInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}
