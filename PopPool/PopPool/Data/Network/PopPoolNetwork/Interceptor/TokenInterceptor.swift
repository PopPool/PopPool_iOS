//
//  TokenInterceptor.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/9/24.
//

import Foundation
import Alamofire

class TokenInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        // TODO: - token header에 주입
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue("Bearer \(credential.accessToken)", forHTTPHeaderField: "Authorization")
    }
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        // TODO: - token refresh 코드
    }
}
