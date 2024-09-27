import RxSwift
import RxCocoa

final class PopupDetailViewModel {
    struct Input {
        let commentType: Driver<CommentType>
        let likeButtonTapped: Driver<Void>
        let shareButtonTapped: Driver<Void>
        let showMoreButtonTapped: Driver<Void>
        let copyAddressButtonTapped: Driver<Void>
        let findRouteButtonTapped: Driver<Void>
        let commentTabChanged: Driver<Int>
        let showAllCommentsButtonTapped: Driver<Void>
        let writeCommentButtonTapped: Driver<Void>
    }

    struct Output {
        let popupData: Driver<PopupDetail>
        let bookmarkToggled: Driver<Bool>
        // TODO: 다른 출력 추가
    }

    private let useCase: PopUpDetailUseCase
    private let popupId: Int64
    private let userId: String
    private let disposeBag = DisposeBag()

    init(useCase: PopUpDetailUseCase, popupId: Int64, userId: String) {
        self.useCase = useCase
        self.popupId = popupId
        self.userId = userId
    }

    func transform(input: Input) -> Output {
        let popupData = input.commentType
            .flatMapLatest { [weak self] commentType -> Driver<PopupDetail> in
                guard let self = self else { return Driver.empty() }
                return self.useCase.getPopupDetail(popUpStoreId: self.popupId, userId: self.userId, commentType: commentType)
                    .asDriver(onErrorJustReturn: .empty)
            }

        let bookmarkToggled = input.likeButtonTapped
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }
                return self.useCase.toggleBookmark(userId: self.userId, popUpStoreId: self.popupId)
                    .andThen(Observable.just(true))
                    .asDriver(onErrorJustReturn: false)
            }


        return Output(
            popupData: popupData,
            bookmarkToggled: bookmarkToggled
        )
    }
}
