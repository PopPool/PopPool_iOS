//
//  PopPoolAPIEndPoint.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/10/24.
//

import Foundation

struct PopPoolAPIEndPoint {
    /// 요청할 API 구조를 구성합니다
    /// - Parameter requestDTO: 요청하고자 하는 데이터 모델을 담습니다
    /// - Returns: 해당 요청의 응답 데이터를 받습니다
    static func tryKakaoLogin(with requestDTO: KakaoLoginRequestDTO) -> Endpoint<LoginResponseDTO> {
        return Endpoint(
            baseURL: "",
            path: "/oauth/kakao/login",
            method: .post,
            bodyParameters: requestDTO
        )
    }
}
