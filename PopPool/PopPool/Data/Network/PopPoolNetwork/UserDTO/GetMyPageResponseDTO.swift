//
//  GetMyPageResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct GetMyPageResponseDTO: Decodable {
    var nickname: String?
    var profileImage: String?
    var instagramId: String?
    var popUpInfoList: [PopUpInfoDTO]
    var login: Bool
}

extension GetMyPageResponseDTO {
    func toDomain() -> GetMyPageResponse {
        return GetMyPageResponse(
            nickname: nickname,
            profileImage: URL(string: profileImage ?? ""),
            instagramId: instagramId,
            popUpInfoList: popUpInfoList.map({ $0.toDomain() }),
            login: login
        )
    }
}

