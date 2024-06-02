//
//  DataResponseDTO.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

// 전달 받은 응답 사항 모델에 맞춰 변경
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
