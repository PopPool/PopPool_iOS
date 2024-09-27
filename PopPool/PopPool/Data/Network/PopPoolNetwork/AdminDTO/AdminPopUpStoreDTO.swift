//
//  AdminPopUpStoreDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 9/9/24.
//

import UIKit

struct AdminPopUpStoreDTO: Codable {
    let id: Int64
    let name: String?
    let category: String?
    let desc: String?
    let address: String?
    let startDate: String?
    let endDate: String?
    let bannerYn: Bool
    let mainImageUrl: String?
    let imageUrl: [String]?
}
