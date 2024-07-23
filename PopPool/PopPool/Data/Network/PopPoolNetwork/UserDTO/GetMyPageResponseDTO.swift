//
//  GetMyPageResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct GetMyPageResponseDTO: Decodable {
    var nickname: String
    var profileImage: String
    var instagramId: String
    var popUpInfoList: [PopUpInfoDTO]
}
