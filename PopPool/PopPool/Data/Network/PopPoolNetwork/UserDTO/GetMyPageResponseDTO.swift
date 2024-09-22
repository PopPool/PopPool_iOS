//
//  GetMyPageResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct GetMyPageResponseDTO: Decodable {
    var nickname: String?
    var profileImageUrl: String?
    var intro: String?
    var instagramId: String?
    var myCommentedPopUpList: [MyCommentedPopUpInfoDTO]
    var loginYn: Bool
    var adminYn: Bool
}

extension GetMyPageResponseDTO {
    func toDomain() -> GetMyPageResponse {
        return GetMyPageResponse(
            nickname: nickname,
            profileImageURL: profileImageUrl,
            instagramId: instagramId,
            popUpInfoList: myCommentedPopUpList.map({ $0.toDomain() }),
            intro: intro,
            isLogin: loginYn,
            isAdmin: adminYn
        )
    }
}

