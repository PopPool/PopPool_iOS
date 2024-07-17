//
//  InterestListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation

// MARK: - InterestListResponseDTO
struct InterestListResponseDTO: Codable {
    let interestResponseList: [InterestResponseDTO]
}

// MARK: - InterestResponse
struct InterestResponseDTO: Codable {
    let interestId: Int64
    let interestCategory: String
}

extension InterestResponseDTO {
    func toDomain() -> Interest {
        return Interest(interestID: interestId, interestName: interestCategory)
    }
}
