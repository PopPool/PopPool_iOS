import Foundation
import RxSwift

protocol PopUpDetailUseCase {
    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail>
    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable
    func getPopUpStoreDirections(popUpStoreId: Int64) -> Observable<GetPopUpStoreDirectionResponseDTO>
    func getUserComments(userId: String, page: Int32, size: Int32, sort: [String]?, commentType: CommentType) -> Observable<GetMyCommentResponseDTO>


}

final class DefaultPopUpDetailUseCase: PopUpDetailUseCase {
    private let repository: PopUpRepository

    init(repository: PopUpRepository) {
        self.repository = repository
    }
    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail> {
        print("PopUpDetailUseCase: getPopupDetail 호출됨")
        return repository.getPopupDetail(popUpStoreId: popUpStoreId, userId: userId, commentType: commentType)
            .do(onNext: { detail in
                print("PopUpDetailUseCase: 팝업 상세 정보 받음")
                print("PopUpDetailUseCase: 이미지 개수: \(detail.imageList.count)")
                print("PopUpDetailUseCase: 댓글 개수: \(detail.commentList.count)")
            }, onError: { error in
                print("PopUpDetailUseCase: 팝업 상세 정보 요청 실패: \(error)")
            })
    }
    func getUserComments(userId: String, page: Int32, size: Int32, sort: [String]?, commentType: CommentType) -> Observable<GetMyCommentResponseDTO> {
          print("Request for user comments initiated.")
          print("Request URL: /users/\(userId)/comments")
          print("Parameters: page = \(page), size = \(size), sort = \(sort ?? []), commentType = \(commentType)")

          return repository.getUserComments(userId: userId, page: page, size: size, sort: sort, commentType: commentType)
              .do(onNext: { response in
                  print("Response 성공. 코멘트 수: \(response.myCommentList.count)")
              }, onError: { error in
                  print("Response 실패: \(error)")
              })
      }
  

    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable {
        return repository.toggleBookmark(userId: userId, popUpStoreId: popUpStoreId)
    }
    func getPopUpStoreDirections(popUpStoreId: Int64) -> Observable<GetPopUpStoreDirectionResponseDTO> {
        return repository.fetchPopUpStoreDirections(popUpStoreId: popUpStoreId)
    }

}
