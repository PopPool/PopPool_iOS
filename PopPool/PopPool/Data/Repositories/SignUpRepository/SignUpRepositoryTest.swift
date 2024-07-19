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
        return Observable.just(false)
    }
    
    func fetchInterestList() -> Observable<[Interest]> {
        
        let interest:[Interest] = [
            .init(interestID: 0, interestName: "게임"),
            .init(interestID: 1, interestName: "라이프스타일"),
            .init(interestID: 2, interestName: "반려동물"),
            .init(interestID: 3, interestName: "뷰티"),
            .init(interestID: 4, interestName: "스포츠"),
            .init(interestID: 5, interestName: "애니메이션"),
            .init(interestID: 6, interestName: "엔터테인먼트"),
            .init(interestID: 7, interestName: "여행"),
            .init(interestID: 8, interestName: "예술"),
            .init(interestID: 9, interestName: "음식/요리"),
            .init(interestID: 10, interestName: "키즈"),
            .init(interestID: 11, interestName: "패션")
        ]
        return Observable.just(interest)
    }
}
