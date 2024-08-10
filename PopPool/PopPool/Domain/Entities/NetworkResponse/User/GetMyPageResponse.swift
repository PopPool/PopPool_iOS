//
//  GetMyPageResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetMyPageResponse {
    var nickname: String?
    var profileImageURL: URL?
    var instagramId: String?
    var popUpInfoList: [MyCommentedPopUpInfo]
    var login: Bool
}
