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
    var mainImageUrl: URL?
    var startDate: String?
    var endDate: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: HomePopUp, rhs: HomePopUp) -> Bool {
        return lhs.id == rhs.id
    }
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
            mainImageUrl: URL(string: mainImageUrl ?? ""),
            startDate: startDate,
            endDate: endDate
        )
    }
}
