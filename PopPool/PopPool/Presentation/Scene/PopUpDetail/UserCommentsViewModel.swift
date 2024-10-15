import Foundation
import RxSwift
import RxCocoa

class UserCommentsViewModel {
    private let useCase: PopUpDetailUseCase
    private let disposeBag = DisposeBag()

    let comments = BehaviorRelay<[MyCommentInfo]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()

    init(useCase: PopUpDetailUseCase) {
        self.useCase = useCase
    }

    func fetchComments(for userId: String, page: Int32 = 0, size: Int32 = 100) {
        isLoading.accept(true)
        useCase.getUserComments(userId: userId, page: page, size: size, sort: ["createDateTime,desc"], commentType: .normal)
            .subscribe(
                onNext: { [weak self] (response: GetMyCommentResponseDTO) in
                    self?.comments.accept(response.myCommentList.map { $0.toDomain() })
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] (error: Error) in
                    self?.error.accept(error)
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
