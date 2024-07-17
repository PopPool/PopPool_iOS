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
            .init(interestID: 0, interestName: "패션"),
            .init(interestID: 1, interestName: "패션1"),
            .init(interestID: 2, interestName: "패션2"),
            .init(interestID: 3, interestName: "패션3"),
            .init(interestID: 4, interestName: "패션4"),
            .init(interestID: 5, interestName: "패션5")
        ]
        return Observable.just(interest)
    }
}
