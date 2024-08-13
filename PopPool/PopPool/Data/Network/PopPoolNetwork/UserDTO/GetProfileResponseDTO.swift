//
//  GetProfileResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetProfileResponseDTO: Decodable {
    var profileImageUrl: String?
    var nickname: String
    var email: String?
    var instagramId: String?
    var intro: String?
    var gender: String
    var age: Int32
    var interestCategoryList: [MyInterestCategoryInfoDTO]
}

extension GetProfileResponseDTO {
    func toDomain() -> GetProfileResponse{
        return GetProfileResponse(
            profileImageUrl: profileImageUrl == nil ? nil : URL(string: profileImageUrl ?? ""),
            nickname: nickname,
            email: email,
            instagramId: instagramId,
            intro: intro,
            gender: gender,
            age: age,
            interestCategoryList: interestCategoryList.map({ $0.toDomain() })
        )
    }
}
