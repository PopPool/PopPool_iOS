//
//  AuthUseCaseImpl.swift
//  PopPool
//
//  Created by SeoJunYoung on 6/19/24.
//

import Foundation
import RxSwift

final class TryLoginUseCaseImpl: TryLoginUseCase {
    
    var repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(userCredential: Encodable, socialType: String) -> Observable<LoginResponse> {
        return repository.tryLogIn(userCredential: userCredential, socialType: socialType)
    }
}
