//
//  UpdateCommentRequest.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation

struct UpdateCommentRequestDTO: Encodable {
    let userId: String
    let popUpStoreId: Int64
    let commentId: Int64
    let comment: String
    let imageUrlList: [ImageActionDTO]
}
