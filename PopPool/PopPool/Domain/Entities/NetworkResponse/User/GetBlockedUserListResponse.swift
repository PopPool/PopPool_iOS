//
//  GetBlockedUserListResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetBlockedUserListResponse {
    var blockedUserInfoList: [BlockedUserInfo]
    var totalPages: Int32
    var totalElements: Int64
}
