//
//  LikeUseCase.swift
//  PopPool
//
//  Created by Porori on 10/3/24.
//

import Foundation
import RxSwift

protocol LikeUseCase {
    func incrementLike(userId: String, commentId: Int64) -> Completable
    func decrementLike(userId: String, commentId: Int64) -> Completable
}
