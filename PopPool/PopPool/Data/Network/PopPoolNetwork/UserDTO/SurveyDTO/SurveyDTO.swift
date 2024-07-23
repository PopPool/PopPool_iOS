//
//  SurveyDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct SurveyDTO: Codable {
    var id: Int64
    var survey: String
}

extension SurveyDTO {
    func toDomain() -> Survey {
        return Survey(
            id: id,
            survey: survey
        )
    }
}
