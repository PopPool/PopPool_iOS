//
//  EndPoint.swift
//  PopPool
//
//  Created by Porori on 6/1/24.
//

import Foundation
import Alamofire

protocol RequesteResponsable: Requestable, Responsable where Response: Decodable {}

/// Entity 데이터 모델인 DTO를 활용해 데이터를 구성합니다
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
