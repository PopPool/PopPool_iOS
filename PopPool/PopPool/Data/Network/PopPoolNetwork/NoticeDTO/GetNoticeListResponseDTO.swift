//
//  GetNoticeListResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/18/24.
//

import Foundation

struct GetNoticeListResponseDTO: Decodable {
    var noticeInfoList: [NoticeInfoDTO]
}

extension GetNoticeListResponseDTO {
    func toDomain() -> GetNoticeListResponse {
        return .init(noticeInfoList: noticeInfoList.map { $0.toDomain() })
    }
}

