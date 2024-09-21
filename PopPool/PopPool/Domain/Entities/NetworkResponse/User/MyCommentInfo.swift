//
//  MyCommentInfo.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct MyCommentInfo {
    var commentId: Int64
    var content: String
    var image: String?
    var likeCount: Int64
    var createDateTime: Date
    var popUpStoreInfo: MyCommentedPopUpInfo
}
