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
    var likeCount: Int64
    var createDateTime: String
    var popUpStoreInfo: MyCommentedPopUpInfoDTO
}

extension MyCommentInfoDTO {
    func toDomain() -> MyCommentInfo {
        return MyCommentInfo(
            commentId: commentId,
            content: content,
            likeCount: likeCount,
            createDateTime: createDateTime.asDate(),
            popUpStoreInfo: popUpStoreInfo.toDomain()
        )
    }
}
