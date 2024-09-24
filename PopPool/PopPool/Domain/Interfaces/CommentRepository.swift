//
//  CommentRepository.swift
//  PopPool
//
//  Created by Porori on 9/24/24.
//

import Foundation
import RxSwift

protocol CommentRepository {
    func postComment(request: CreateCommentRequestDTO) -> Completable
    func updateComment(request: UpdateCommentRequestDTO) -> Completable
    func deleteComment(id: String, popUpId: Int64, commentId: Int64) -> Completable
}
