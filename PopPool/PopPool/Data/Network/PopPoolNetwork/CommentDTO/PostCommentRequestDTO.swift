//
//  PostCommentRequestDTO.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation

struct CreateCommentRequestDTO: Encodable {
    let userId: String
    let popUpStoreId: Int64
    let content: String
    let commentType: CommentType
    let imageUrlList: [ImageActionDTO]
}
