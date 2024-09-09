//
//  UpdatePopUpStoreRequest.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import UIKit

struct UpdatePopUpStoreRequestDTO: Encodable {
    let popUpStore: [AdminPopUpStoreDTO]
    let location: Location
    let imagesToAdd: [String]
    let imagesToDelete: [Int64]
}
