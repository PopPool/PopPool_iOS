//
//  KakaoLoginRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct KakaoLoginRequestDTO: Encodable {
    var kakaoUserId: String
    var kakaoAccessToken: String
}
