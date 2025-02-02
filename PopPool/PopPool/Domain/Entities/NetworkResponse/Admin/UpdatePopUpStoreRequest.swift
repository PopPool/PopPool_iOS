//
//  UpdatePopUpStoreRequest.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct UpdatePopUpStoreRequest {
    let popUpStore: [MapPopUpStore]
    let location: Location
    let imagesToAdd: [URL?]
    let imagesToDelete: [Int64]
}
