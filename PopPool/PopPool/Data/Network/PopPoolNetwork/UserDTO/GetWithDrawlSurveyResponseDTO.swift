//
//  GetWithDrawlSurveyResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetWithDrawlSurveyResponseDTO: Decodable {
    var withDrawlSurveyList: [SurveyDTO]
}

extension GetWithDrawlSurveyResponseDTO {
    func toDomain() -> GetWithDrawlSurveyResponse {
        return GetWithDrawlSurveyResponse(
            withDrawlSurveyList: withDrawlSurveyList.map({ $0.toDomain() })
        )
    }
}

