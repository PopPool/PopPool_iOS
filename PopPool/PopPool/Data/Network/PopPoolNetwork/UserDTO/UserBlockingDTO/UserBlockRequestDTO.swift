//
//  UserBlockRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct UserBlockRequestDTO: Encodable {
    var blockerUserId: String
    var blockedUserId: String
}
