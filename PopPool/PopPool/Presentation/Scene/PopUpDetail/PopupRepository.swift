import Foundation
import RxSwift

protocol PopUpRepository {
    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail>
    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable
    func fetchPopUpStoreDirections(popUpStoreId: Int64) -> Observable<GetPopUpStoreDirectionResponseDTO>
    func getUserComments(userId: String, page: Int32, size: Int32, sort: [String]?, commentType: CommentType) -> Observable<GetMyCommentResponseDTO>


}

final class DefaultPopUpRepository: PopUpRepository {
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor
    
    init(provider: Provider, tokenInterceptor: TokenInterceptor) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }
    
    func getPopupDetail(popUpStoreId: Int64, userId: String, commentType: CommentType) -> Observable<PopupDetail> {
        let endpoint = PopPoolAPIEndPoint.popup_getDetail(popUpStoreId: popUpStoreId, userId: userId, commentType: commentType)
        return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
    }
    
    func toggleBookmark(userId: String, popUpStoreId: Int64) -> Completable {
        let request = UserBookMarkRequestDTO(popUpStoreId: popUpStoreId)
        let endpoint = PopPoolAPIEndPoint.user_updateBookMarkPopUpStore(userId: userId, reqeust: request)
        return provider.request(with: endpoint, interceptor: tokenInterceptor)
    }
    func fetchPopUpStoreDirections(popUpStoreId: Int64) -> Observable<GetPopUpStoreDirectionResponseDTO> {
        let endpoint = PopPoolAPIEndPoint.popup_getDirections(popUpStoreId: popUpStoreId)
        return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
    }
    func getUserComments(userId: String, page: Int32, size: Int32, sort: [String]?, commentType: CommentType) -> Observable<GetMyCommentResponseDTO> {
           let endpoint = PopPoolAPIEndPoint.user_getMyComment(
               userId: userId,
               request: GetMyCommentRequestDTO(page: page, size: size, sort: sort, commentType: commentType)
           )
           return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
       }
   }

