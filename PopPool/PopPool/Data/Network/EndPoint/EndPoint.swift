//
//  EndPoint.swift
//  PopPool
//
//  Created by Porori on 6/1/24.
//

import Foundation

// 직접 채택하지 않고 Responsable protocol을 사용하는 이유는 잘 모르겠다
protocol RequesteResponsable: Requestable, Responsable where Response: Decodable {}

/// 최종 URL의 데이터 구조를 정리하는 구조체
class Endpoint<R: Decodable>: RequesteResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String: String]?
    var sampleData: Data?

    init(baseURL: String,
         path: String = "",
         method: HTTPMethod = .get,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String: String]? = [:],
         sampleData: Data? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.sampleData = sampleData
    }
}

/// 네트워크 통신에서 활용할 방식
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
