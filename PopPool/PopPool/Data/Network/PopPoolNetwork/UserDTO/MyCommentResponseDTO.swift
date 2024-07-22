//
//  MyCommentResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct MyCommentResponseDTO: Decodable {
    var myCommentList: [MyCommentInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}
