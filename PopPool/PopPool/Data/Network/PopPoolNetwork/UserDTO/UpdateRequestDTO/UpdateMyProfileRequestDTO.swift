//
//  UpdateMyProfileRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct UpdateMyProfileRequestDTO: Encodable {
    var profileImage: String?
    var nickname: String
    var email: String?
    var instagramId: String?
    var intro: String?
}

