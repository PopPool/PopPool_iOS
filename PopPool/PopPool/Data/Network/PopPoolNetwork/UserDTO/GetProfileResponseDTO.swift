//
//  GetProfileResponseDTO.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetProfileResponseDTO: Decodable {
    var profileImage: String
    var nickname: String
    var email: String
    var instagramId: String
    var intro: String
    var gender: String
    var age: Int32
    var interestList: [MyInterestInfoDTO]
}

extension GetProfileResponseDTO {
    func toDomain() -> GetProfileResponse{
        return GetProfileResponse(
            profileImage: URL(string: profileImage),
            nickname: nickname,
            email: email,
            instagramId: instagramId,
            intro: intro,
            gender: gender,
            age: age,
            interestList: interestList.map({ $0.toDomain() })
        )
    }
}
