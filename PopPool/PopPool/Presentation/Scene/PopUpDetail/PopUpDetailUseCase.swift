import Foundation
import RxSwift

protocol PopUpDetailUseCase {
    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail>
    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable
}

final class DefaultPopUpDetailUseCase: PopUpDetailUseCase {
    private let repository: PopUpRepository

    init(repository: PopUpRepository) {
        self.repository = repository
    }

    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail> {
        return repository.getPopupDetail(popUpStoreId: popUpStoreId, userId: userId, commentType: commentType)
    }

    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable {
        return repository.toggleBookmark(userId: userId, popUpStoreId: popUpStoreId)
    }
}
