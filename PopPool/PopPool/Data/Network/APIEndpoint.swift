//
//  APIEndpoint.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

struct APIEndpoint {
    /// 요청할 API 구조를 구성합니다
    /// - Parameter requestDTO: 요청하고자 하는 데이터 모델을 담습니다
    /// - Returns: 해당 요청의 응답 데이터를 받습니다
    static func fetchData(with requestDTO: TestRequestDTO) -> Endpoint<TestResponseDTO> {
        return Endpoint(
            baseURL: "https://api.chucknorris.io/jokes",
            path: "/random",
            method: .get,
            queryParameters: requestDTO
        )
    }
}
