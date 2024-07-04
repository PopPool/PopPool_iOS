//
//  InterestListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation

// MARK: - InterestListResponseDTO
struct InterestListResponseDTO: Codable {
    let interestResponse: [InterestResponseDTO]
}

// MARK: - InterestResponse
struct InterestResponseDTO: Codable {
    let interestID, interestName: String
}

extension InterestResponseDTO {
    func toDomain() -> Interest {
        return Interest(interestID: interestID, interestName: interestName)
    }
}
