//
//  AdminUseCaseImpl.swift
//  PopPool
//
//  Created by Porori on 8/27/24.
//

import Foundation
import RxSwift

final class AdminUseCaseImpl: AdminUseCase {
    
    var repository: AdminRepository
    
    init(repository: AdminRepository) {
        self.repository = repository
    }
    
    func postNotice(title: String, content: String) -> Completable {
        return repository.postNotice(title: title, content: content)
    }
    
    func updateNotice(noticeId: Int64, title: String, content: String) -> Completable {
        return repository.updateNotice(noticeId: noticeId, title: title, content: content)
    }
    
    func deleteNotice(noticeId: Int64, adminId: String) -> Completable {
        return repository.deleteNotice(noticeId: noticeId, adminId: adminId)
    }
}
