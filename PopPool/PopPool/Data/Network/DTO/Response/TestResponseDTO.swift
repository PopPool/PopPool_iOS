//
//  DataResponseDTO.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

/// 전달 받을 데이터의 구조입니다
/// 어떤 데이터를 받는지에 따라 새로 구성해야합니다
struct TestResponseDTO: Decodable {
    let iconUrl: String
    let id: String
    let url: String
    let value: String
    
    // Custom keys mapping
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case id
        case url
        case value
    }
}
