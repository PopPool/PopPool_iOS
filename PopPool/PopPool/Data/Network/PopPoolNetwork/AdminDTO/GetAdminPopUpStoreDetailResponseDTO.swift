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
    let address: String?
    let startDate: String
    let endDate: String
    let createUserId: String
    let createDateTime: String
    let mainImageUrl: String?
    let imageList: [ImageDTO]
    let latitude: Double
    let longitude: Double
    let markerTitle: String?
    let markerSnippet: String?
}

struct ImageDTO: Decodable {
    var id: Int64
    var imageUrl: String
}
