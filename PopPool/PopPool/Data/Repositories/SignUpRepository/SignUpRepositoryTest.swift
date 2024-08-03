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
    
    func fetchCategoryList() -> Observable<[Category]> {
        
        let interest:[Category] = [
            .init(categoryId: 0, category: "게임"),
            .init(categoryId: 1, category: "라이프스타일"),
            .init(categoryId: 2, category: "반려동물"),
            .init(categoryId: 3, category: "뷰티"),
            .init(categoryId: 4, category: "스포츠"),
            .init(categoryId: 5, category: "애니메이션"),
            .init(categoryId: 6, category: "엔터테인먼트"),
            .init(categoryId: 7, category: "여행"),
            .init(categoryId: 8, category: "예술"),
            .init(categoryId: 9, category: "음식/요리"),
            .init(categoryId: 10, category: "키즈"),
            .init(categoryId: 11, category: "패션")
        ]
        return Observable.just(interest)
    }
    
    func trySignUp(
        userId: String,
        nickName: String,
        gender: String,
        age: Int32,
        socialEmail: String?,
        socialType: String,
        interests: [Int]
    ) -> Completable {
        return Completable.create { observer in
            observer(.completed)
            return Disposables.create()
        }
    }
}
