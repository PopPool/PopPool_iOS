//
//  CreatePopUpStoreRequest.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct CreatePopUpStoreRequestDTO: Decodable {
    let name: String
    let category: String
    let desc: String
    let address: String
    let startDate: String
    let endDate: String
    let mainImageUrl: String
    let imageUrlList: [String]
    let latitude: Double
    let longitude: Double
}
