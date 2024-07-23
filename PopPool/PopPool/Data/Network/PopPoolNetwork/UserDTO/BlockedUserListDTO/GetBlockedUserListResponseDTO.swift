//
//  GetBlockedUserListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetBlockedUserListResponseDTO: Decodable, PageableResponse {
    var blockedUserInfoList: [BlockedUserInfoDTO]
    var totalPages: Int32
    var totalElements: Int64
}

extension GetBlockedUserListResponseDTO {
    func toDomain() -> GetBlockedUserListResponse {
        return GetBlockedUserListResponse(
            blockedUserInfoList: blockedUserInfoList.map({ $0.toDomain() }),
            totalPages: totalPages,
            totalElements: totalElements
        )
    }
}

