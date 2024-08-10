//
//  PopUpStoreDTO.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import CoreLocation

struct PopUpStoreDTO: Decodable {
    let id: String
    let name: String
    let category: String
    let latitude: Double
    let longitude: Double
    let address: String
    let dateRange: String

    func toDomain() -> PopUpStore {
        return PopUpStore(
            id: id,
            name: name,
            categories: [category], // 문자열을 배열로 변환
            location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            address: address,
            dateRange: dateRange
        )
    }
}
