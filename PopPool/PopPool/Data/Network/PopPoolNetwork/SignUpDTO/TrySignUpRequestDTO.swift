//
//  TrySignUpRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation

struct TrySignUpRequestDTO: Encodable {
    var userId: String
    var nickName: String
    var gender: String
    var age: Int
    var socialType: String
    var interests: [String]
}



