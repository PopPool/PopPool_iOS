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
    let startDate: Date
    let endDate: Date
    let createUserId: String
    let createDateTime: Date
    let mainImageUrl: String?
    let imageUrlList: [String?]
    let latitude: Double
    let longitude: Double
    let markerTitle: String
    let markerSnippet: String
}
