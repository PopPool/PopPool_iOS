//
//  PopPoolAPIEndPoint.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    
    /// 요청할 API 구조를 구성합니다
    /// - Parameters:
    ///   - userCredential: 사용자 자격 증명
    ///   - path: API 경로
    /// - Returns: 로그인 응답 DTO를 반환하는 Endpoint
    static func tryLogin(with userCredential: Encodable, path: String) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: "http://localhost:8080",
            path: "/auth/\(path)",
            method: .post,
            bodyParameters: userCredential
        )
    }
}
