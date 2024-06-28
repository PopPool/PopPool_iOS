//
//  MyAuthenticationCredential.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/28/24.
//

import Foundation

struct MyAuthenticationCredential: Encodable {
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresIn: Int
    var refreshTokenExpiresIn: Int
}
