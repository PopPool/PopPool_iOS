//
//  GetMyCommentResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyCommentResponse {
    var myCommentList: [MyCommentInfo]
    var totalPages: Int32
    var totalElements: Int64
}
