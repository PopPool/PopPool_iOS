//
//  PopUpInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/22/24.
//

import Foundation

struct PopUpInfoDTO: Decodable {
    var popUpStoreId: Int64
    var popUpStoreName: String
    var desc: String
    var startDate: String
    var endDate: String
    var address: String
    var closeYn: Bool
}

extension PopUpInfoDTO {
    func toDomain() -> PopUpInfo {
        return PopUpInfo(
            popUpStoreId: popUpStoreId,
            popUpStoreName: popUpStoreName,
            desc: desc,
            startDate: startDate.asDate(),
            endDate: endDate.asDate(),
            address: address,
            closedYn: closeYn
        )
    }
}
