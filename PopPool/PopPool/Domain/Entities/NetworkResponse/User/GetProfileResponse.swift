//
//  GetProfileResponse.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

struct GetProfileResponse {
    var profileImageUrl: String?
    var nickname: String
    var email: String?
    var instagramId: String?
    var intro: String?
    var gender: String
    var age: Int32
    var interestCategoryList: [MyInterestCategoryInfo]
}
