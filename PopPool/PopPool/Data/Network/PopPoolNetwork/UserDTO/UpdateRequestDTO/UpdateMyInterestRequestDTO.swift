//
//  UpdateMyInterestRequestDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct UpdateMyInterestRequestDTO: Encodable {
    var interestCategoriesToAdd: [Int64]
    var interestCategoriesToDelete: [Int64]
    var interestCategoriesToKeep: [Int64]
}
