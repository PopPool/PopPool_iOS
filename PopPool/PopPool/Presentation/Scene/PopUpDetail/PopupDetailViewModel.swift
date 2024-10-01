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
        print("PopupDetailViewModel: transform 메서드 호출됨")

        let popupData = input.commentType
            .flatMapLatest { [weak self] commentType -> Driver<PopupDetail> in
                guard let self = self else {
                    print("PopupDetailViewModel: self가 nil입니다")
                    return Driver.empty()
                }
                print("PopupDetailViewModel: 팝업 상세 정보 요청 시작. popUpStoreId: \(self.popupId), userId: \(self.userId), commentType: \(commentType)")
                return self.useCase.getPopupDetail(popUpStoreId: self.popupId, userId: self.userId, commentType: commentType)
                    .do(onNext: { detail in
                        print("PopupDetailViewModel: 팝업 상세 정보 받음: \(detail.name)")
                        print("PopupDetailViewModel: 이미지 개수: \(detail.imageList.count)")
                        print("PopupDetailViewModel: 댓글 개수: \(detail.commentList.count)")
                    })
                    .asDriver(onErrorJustReturn: .empty)
            }

        let bookmarkToggled = input.likeButtonTapped
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let self = self else {
                    print("PopupDetailViewModel: self가 nil입니다 (북마크 토글)")
                    return Driver.just(false)
                }
                print("PopupDetailViewModel: 북마크 토글 요청 시작. popUpStoreId: \(self.popupId), userId: \(self.userId)")
                return self.useCase.toggleBookmark(userId: self.userId, popUpStoreId: self.popupId)
                    .andThen(Observable.just(true))
                    .do(onNext: { success in
                        print("PopupDetailViewModel: 북마크 토글 결과: \(success)")
                    })
                    .asDriver(onErrorJustReturn: false)
            }

        return Output(
            popupData: popupData,
            bookmarkToggled: bookmarkToggled
        )
    }
}

