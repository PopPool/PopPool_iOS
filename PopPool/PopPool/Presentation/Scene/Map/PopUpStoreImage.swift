//
//  PopUpStoreImage.swift
//  PopPool
//
//  Created by 김기현 on 9/4/24.
//

import Foundation

// 팝업 스토어 이미지 구조체
struct PopUpStoreImage: Codable {
    let id: Int
    let category: String
    let name: String
    let address: String
    let mainImageUrl: String?
    let startDate: String?
    let endDate: String?
}

// 응답 DTO 구조체
struct GetCustomPopUpStoreImageResponseDTO: Codable {
    let customPopUpStoreList: [PopUpStoreImage] 
    let customPopUpStoreTotalPages: Int?  // 페이지 수
    let customPopUpStoreTotalElements: Int?  // 전체 요소 수
}
