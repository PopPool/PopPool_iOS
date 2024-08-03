//
//  LoginResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/19/24.
//

import Foundation

struct LoginResponse: Decodable {
    var userId: String
    var grantType: String
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresAt: String
    var refreshTokenExpiresAt: String
    var socialType: String
    var registeredUser: Bool
}
