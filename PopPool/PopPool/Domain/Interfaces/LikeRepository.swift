//
//  LikeRepository.swift
//  PopPool
//
//  Created by Porori on 10/3/24.
//

import Foundation
import RxSwift

protocol LikeRepository {
    func incrementLike(userId: String, commentId: Int64) -> Completable
    func decrementLike(userId: String, commentId: Int64) -> Completable
}
