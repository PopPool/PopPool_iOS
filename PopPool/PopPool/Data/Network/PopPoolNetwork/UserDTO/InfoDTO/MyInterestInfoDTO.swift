//
//  MyInterestInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct MyInterestInfoDTO: Decodable {
    var interestId: Int64
    var interestCategory: String
}
extension MyInterestInfoDTO {
    func toDomain() -> MyInterestInfo {
        return MyInterestInfo(
            interestId: interestId,
            interestCategory: interestCategory
        )
    }
}
