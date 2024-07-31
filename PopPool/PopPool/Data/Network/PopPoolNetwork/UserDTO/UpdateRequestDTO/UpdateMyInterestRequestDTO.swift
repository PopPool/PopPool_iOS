//
//  UpdateMyInterestRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct UpdateMyInterestRequestDTO: Encodable {
    var interestsToAdd: [Int64]
    var interestsToDelete: [Int64]
    var interestsToKeep: [Int64]
}
