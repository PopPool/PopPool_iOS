//
//  Survey.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct Survey: Equatable {
    var id: Int64
    var survey: String
}

extension Survey {
    func toRequestDTO() -> CheckedSurveyDTO {
        return CheckedSurveyDTO(
            id: id,
            survey: survey
        )
    }
}
