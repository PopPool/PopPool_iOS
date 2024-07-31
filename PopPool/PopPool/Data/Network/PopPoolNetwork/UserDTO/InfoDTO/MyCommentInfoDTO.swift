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

extension MyCommentInfoDTO {
    func toDomain() -> MyCommentInfo {
        return MyCommentInfo(
            commentId: commentId,
            content: content,
            image: URL(string: image),
            likeCount: likeCount
        )
    }
}


