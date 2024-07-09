//
//  LoginResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/19/24.
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
    var registeredUser: Bool
}

extension LoginResponseDTO {
    func toDomain() -> LoginResponse {
        return .init(
            userId: userId,
            grantType: grantType,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessTokenExpiresIn: accessTokenExpiresIn, 
            refreshTokenExpiresIn: refreshTokenExpiresIn,
            socialType: socialType,
            registeredUser: registeredUser
        )
    }
}
