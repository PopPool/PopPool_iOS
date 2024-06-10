//
//  LoginResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    var userId: String
    var grantType: String
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresIn: Int
    var refreshTokenExpiresIn: Int
    var socialType: String
}
