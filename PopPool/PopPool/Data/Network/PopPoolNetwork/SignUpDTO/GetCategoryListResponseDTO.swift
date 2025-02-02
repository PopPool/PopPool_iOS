//
//  GetCategoryListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/29/24.
//

import Foundation

// MARK: - GetCategoryListResponseDTO
struct GetCategoryListResponseDTO: Codable {
    let categoryResponseList: [CategoryResponseDTO]
}

// MARK: - InterestResponse
struct CategoryResponseDTO: Codable {
    let categoryId: Int64
    let category: String
}

extension CategoryResponseDTO {
    func toDomain() -> Category {
        return Category(categoryId: categoryId, category: category)
    }
}
