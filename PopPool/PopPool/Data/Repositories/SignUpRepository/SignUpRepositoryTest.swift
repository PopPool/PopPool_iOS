//
//  SignUpRepositoryTest.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/4/24.
//

import Foundation
import RxSwift

final class SignUpRepositoryTest: SignUpRepository {
    
    func checkNickName(nickName: String) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func fetchInterestList() -> Observable<[Interest]> {
        
        let interest:[Interest] = [
            .init(interestID: "FASION", interestName: "FASION"),
            .init(interestID: "LIFESTYLE", interestName: "LIFESTYLE"),
            .init(interestID: "BEAUTY", interestName: "BEAUTY"),
            .init(interestID: "FOOD_COOKING", interestName: "FOOD_COOKING"),
            .init(interestID: "ART", interestName: "ART"),
            .init(interestID: "PETS", interestName: "PETS"),
            .init(interestID: "TRAVEL", interestName: "TRAVEL"),
            .init(interestID: "ENTERTAINMENT", interestName: "ENTERTAINMENT"),
            .init(interestID: "ANIMATION", interestName: "ANIMATION"),
            .init(interestID: "KIDS", interestName: "KIDS"),
            .init(interestID: "SPORTS", interestName: "SPORTS"),
            .init(interestID: "GAMES", interestName: "GAMES"),
        ]
        return Observable.just(interest)
    }
}
