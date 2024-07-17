//
//  SignUpUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/17/24.
//

import Foundation
import RxSwift

final class SignUpUseCaseImpl: SignUpUseCase {
    var repository: SignUpRepository
    
    init(repository: SignUpRepository) {
        self.repository = repository
    }

    func checkNickName(nickName: String) -> Observable<Bool> {
        return repository.checkNickName(nickName: nickName)
    }
    
    func fetchInterestList() -> Observable<[Interest]> {
        return repository.fetchInterestList()
    }
}
