//
//  UpdatePopUpStoreRequest.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct UpdatePopUpStoreRequestDTO: Decodable {
    let popUpStore: [PopUpStoreDTO]
    let location: Location
    let imagesToAdd: [String]
    let imagesToDelete: [Int64]
}

extension UpdatePopUpStoreRequestDTO {
    func toDomain() -> UpdatePopUpStoreRequest {
        return .init(popUpStore: popUpStore.map{ $0.toDomain() },
                     location: location,
                     imagesToAdd: imagesToAdd,
                     imagesToDelete: imagesToDelete)
    }
}
