//
//  TestRequestDTO.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

/// 요청할 데이터의 구조입니다
/// 어떤 데이터를 요청하는지에 따라 새로 구성해야합니다
struct TestRequestDTO: Encodable {
    var query: String?
    var api_Key: String?
}
