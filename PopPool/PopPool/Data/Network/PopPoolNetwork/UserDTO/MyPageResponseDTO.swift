//
//  MyPageResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct MyPageResponseDTO: Decodable {
    var nickname: String
    var instagramId: String
    var popUpInfoList: [PopUpInfoDTO]
}
