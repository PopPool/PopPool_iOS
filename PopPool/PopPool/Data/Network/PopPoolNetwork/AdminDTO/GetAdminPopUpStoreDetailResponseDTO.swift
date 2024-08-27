//
//  GetAdminPopUpStoreDetailResponse.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct GetAdminPopUpStoreDetailResponseDTO: Decodable {
    let id: Int64
    let name: String
    let category: String
    let desc: String
    let address: String
    let startDate: String
    let endDate: String
    let createUserId: String
    let createDateTime: String
    let mainImageUrl: String
    let imageUrlList: [String]
    let latitude: Double
    let longitude: Double
    let markerTitle: String
    let markerSnippet: String
}

extension GetAdminPopUpStoreDetailResponseDTO {
    func toDomain() -> GetAdminPopUpStoreDetailResponse {
        return .init(
            id: id,
            name: name,
            category: category,
            desc: desc,
            address: address,
            startDate: startDate,
            endDate: endDate,
            createUserId: createUserId,
            createDateTime: createDateTime,
            mainImageUrl: mainImageUrl,
            imageUrlList: imageUrlList,
            latitude: latitude,
            longitude: longitude,
            markerTitle: markerTitle,
            markerSnippet: markerSnippet
        )
    }
}
