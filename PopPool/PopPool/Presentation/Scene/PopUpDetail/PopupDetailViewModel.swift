import RxSwift
import RxCocoa

final class PopupDetailViewModel {
    struct Input {
        let commentType: Driver<CommentType>
        let bookmarkButtonTapped: Driver<Void>
        let shareButtonTapped: Driver<Void>
        let showMoreButtonTapped: Driver<Void>
        let findRouteButtonTapped: Driver<Void>
        let commentTabChanged: Driver<Int>
        let showAllCommentsButtonTapped: Driver<Void>
        let writeCommentButtonTapped: Driver<Void>

    }

    struct Output {
        let popupData: Driver<PopupDetail>
        let bookmarkToggled: Driver<Bool>
        let directionsData: Driver<GetPopUpStoreDirectionResponseDTO> // 좌표값 데이터 추가... ㅜ


        // TODO: 다른 출력 추가
    }

    private let useCase: PopUpDetailUseCase
    let popupId: Int64
    private let userId: String
    private let disposeBag = DisposeBag()
    private let popupDataRelay = BehaviorRelay<PopupDetail?>(value: nil)
    private let commentTypeRelay = BehaviorRelay<CommentType>(value: .normal)
    let userCommentsViewModel: UserCommentsViewModel



    init(useCase: PopUpDetailUseCase, popupId: Int64, userId: String, userCommentsViewModel: UserCommentsViewModel) {
        self.userCommentsViewModel = userCommentsViewModel
        self.useCase = useCase
        self.popupId = popupId
        self.userId = userId
    }

    func transform(input: Input) -> Output {
        let popupData = input.commentType
            .flatMapLatest { [weak self] commentType -> Driver<PopupDetail> in
                guard let self = self else { return Driver.empty() }
                return self.fetchPopupDetail(commentType: commentType)
            }
            .do(onNext: { [weak self] detail in
                self?.popupDataRelay.accept(detail)
            })

        let bookmarkToggled = input.bookmarkButtonTapped
            .flatMapLatest { [weak self] _ -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }

                // 현재 북마크 상태 확인
                guard let currentBookmarkState = self.popupDataRelay.value?.bookmarkYn else {
                    return Driver.just(false)
                }

                // 서버에 토글 요청 후 새로운 상태 반환
                return self.useCase.toggleBookmark(userId: self.userId, popUpStoreId: self.popupId)
                    .andThen(Observable.just(!currentBookmarkState)) // 상태를 반대로 토글
                    .do(onNext: { newState in
                        // popupDataRelay에 업데이트 반영
                        if var popupDetail = self.popupDataRelay.value {
                            popupDetail.bookmarkYn = newState
                            self.popupDataRelay.accept(popupDetail) // 업데이트된 상태를 반영
                        }
                    })
                    .asDriver(onErrorJustReturn: currentBookmarkState)
            }

        let directionsData = input.findRouteButtonTapped
                   .flatMapLatest { [weak self] _ -> Driver<GetPopUpStoreDirectionResponseDTO> in
                       guard let self = self else { return Driver.empty() }
                       return self.fetchDirections() // API 호출하여 좌표 데이터 가져오기
                   }



        return Output(
            popupData: popupData,
            bookmarkToggled: bookmarkToggled,
            directionsData: directionsData

//            addressCopied: addressCopied
        )
    }

    func refreshComments() {
           let currentCommentType = commentTypeRelay.value
           fetchPopupDetail(commentType: currentCommentType)
               .drive(onNext: { [weak self] detail in
                   self?.popupDataRelay.accept(detail)
               })
               .disposed(by: disposeBag)
       }
    private func fetchDirections() -> Driver<GetPopUpStoreDirectionResponseDTO> {
           return useCase.getPopUpStoreDirections(popUpStoreId: popupId) // 길찾기 API 호출
               .asDriver(onErrorJustReturn: .empty)
       }


      private func fetchPopupDetail(commentType: CommentType) -> Driver<PopupDetail> {
          print("PopupDetailViewModel: 팝업 상세 정보 요청 시작. popUpStoreId: \(popupId), userId: \(userId), commentType: \(commentType)")
          return useCase.getPopupDetail(popUpStoreId: popupId, userId: userId, commentType: commentType)
              .do(onNext: { detail in
                  print("PopupDetailViewModel: 팝업 상세 정보 받음: \(detail.name)")
                  print("PopupDetailViewModel: 이미지 개수: \(detail.imageList.count)")
                  print("PopupDetailViewModel: 댓글 개수: \(detail.commentList.count)")
                  print("PopupDetailViewModel: 첫 번째 이미지 URL: \(detail.imageList.first?.imageUrl ?? "없음")")
              })
              .asDriver(onErrorJustReturn: .empty)
      }
  }

