//
//  HomePopUp.swift
//  PopPool
//
//  Created by Porori on 8/28/24.
//

import Foundation

struct HomePopUp: Codable, Hashable {
    var id: Int64
    var category: String
    var name: String
    var address: String
    var mainImageUrl: String?
    var startDate: String?
    var endDate: String?
}

struct HomePopUpDTO: Decodable {
    var id: Int64
    var category: String
    var name: String
    var address: String
    var mainImageUrl: String?
    var startDate: String?
    var endDate: String?
}

extension HomePopUpDTO {
    func toDomain() -> HomePopUp {
        return HomePopUp(
            id: id,
            category: category,
            name: name,
            address: address,
            mainImageUrl: mainImageUrl,
            startDate: startDate,
            endDate: endDate
        )
    }
}
