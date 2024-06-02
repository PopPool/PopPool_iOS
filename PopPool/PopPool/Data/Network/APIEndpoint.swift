//
//  APIEndpoint.swift
//  PopPool
//
//  Created by Porori on 6/2/24.
//

import Foundation

struct APIEndpoint {
    static func fetchData(with requestDTO: TestRequestDTO) -> Endpoint<TestResponseDTO> {
        return Endpoint(
            baseURL: "https://api.chucknorris.io/jokes",
            path: "/random",
            method: .get,
            queryParameters: requestDTO
        )
    }
}
