//
//  FetchInterestListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation

struct FetchInterestListResponseDTO: Decodable {
    let interestResponseList: [InterestResponse]
    
    struct InterestResponse: Codable {
        let interestName: String
    }
}
