//
//  GetAdminPopUpStoreListResponse.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation

struct GetAdminPopUpStoreListResponseDTO: Decodable {
    let popUpStoreList: [AdminPopUpStoreDTO]
    let totalPages: Int32
    let totalElements: Int64
}
