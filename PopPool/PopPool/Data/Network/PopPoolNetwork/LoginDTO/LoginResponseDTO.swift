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
    var accessTokenExpiresAt: String
    var refreshTokenExpiresAt: String
    var socialType: String
    var registeredUserYn: Bool
}

extension LoginResponseDTO {
    func toDomain() -> LoginResponse {
        return .init(
            userId: userId,
            grantType: grantType,
            accessToken: accessToken,
            refreshToken: refreshToken,
            accessTokenExpiresAt: accessTokenExpiresAt,
            refreshTokenExpiresAt: refreshTokenExpiresAt,
            socialType: socialType,
            isRegisteredUser: registeredUserYn
        )
    }
}
