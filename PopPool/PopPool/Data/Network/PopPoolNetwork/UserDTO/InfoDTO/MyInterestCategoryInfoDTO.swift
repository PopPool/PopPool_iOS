//
//  MyInterestCategoryInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct MyInterestCategoryInfoDTO: Decodable {
    var categoryId: Int64
    var interestCategory: String
}
extension MyInterestCategoryInfoDTO {
    func toDomain() -> MyInterestCategoryInfo {
        return MyInterestCategoryInfo(
            categoryId: categoryId,
            interestCategory: interestCategory
        )
    }
}
