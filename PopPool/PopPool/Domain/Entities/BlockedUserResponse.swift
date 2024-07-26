//
//  BlockedUser.swift
//  PopPool
//
//  Created by Porori on 7/23/24.
//

import Foundation

struct BlockedUserResponse: Decodable {
    let blockedUserInfoList: [UserBlocked]
    let totalPages: Int
    let totalElements: Int
}

struct UserBlocked: Decodable {
    let userId: String
    let profileImage: String
    let nickname: String
    let instagramId: String
}
