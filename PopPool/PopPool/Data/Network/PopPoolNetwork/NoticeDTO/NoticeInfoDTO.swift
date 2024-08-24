//
//  NoticeInfoDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/18/24.
//

import Foundation

struct NoticeInfoDTO: Decodable {
    var id: Int64
    var title: String
    var createdDateTime: String
}

extension NoticeInfoDTO {
    func toDomain() -> NoticeInfo {
        return .init(id: id, title: title, date: createdDateTime.asDate())
    }
}
