//
//  BlockedUserInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct BlockedUserInfoDTO: Decodable {
    var userId: String
    var profileImageUrl: String?
    var nickname: String
    var instagramId: String?
}

extension BlockedUserInfoDTO {
    func toDomain() -> BlockedUserInfo {
        return BlockedUserInfo(
            userId: userId,
            profileImage: profileImageUrl,
            nickname: nickname,
            instagramId: instagramId
        )
    }
}
