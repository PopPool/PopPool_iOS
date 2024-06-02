//
//  DataRequestDTO.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

// 우리가 보낼 요청 사항 모델에 맞춰 변경
struct RequestDTO: Encodable {
    var query: String
    var api_Key: String?
}
