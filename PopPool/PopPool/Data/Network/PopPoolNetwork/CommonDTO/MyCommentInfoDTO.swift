//
//  MyCommentInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct MyCommentInfoDTO: Decodable {
    var commentId: Int64
    var content: String
    var image: String
    var likeCount: Int32
}
