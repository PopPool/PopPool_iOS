//
//  MyCommentedPopUpInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/9/24.
//

import Foundation

struct MyCommentedPopUpInfoDTO: Decodable {
    var popUpStoreId: Int64
    var popUpStoreName: String
    var mainImageUrl: String
}

extension MyCommentedPopUpInfoDTO {
    func toDomain() -> MyCommentedPopUpInfo {
        return .init(
            popUpStoreId: popUpStoreId,
            popUpStoreName: popUpStoreName,
            mainImageUrl: mainImageUrl
        )
    }
}
