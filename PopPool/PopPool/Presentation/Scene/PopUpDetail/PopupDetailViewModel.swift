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
        let addressCopied: Driver<String> 

        // TODO: 다른 출력 추가
    }

    private let useCase: PopUpDetailUseCase
    let popupId: Int64
    private let userId: String
    private let disposeBag = DisposeBag()
    private let popupDataRelay = BehaviorRelay<PopupDetail?>(value: nil)
    private let commentTypeRelay = BehaviorRelay<CommentType>(value: .normal)



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
                return self.fetchPopupDetail(commentType: commentType)
            }
            .do(onNext: { [weak self] detail in
                self?.popupDataRelay.accept(detail)
            })


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
        let addressCopied = input.copyAddressButtonTapped
            .withLatestFrom(popupDataRelay.asDriver()) 
                  .compactMap { popup -> String? in
                      guard let address = popup?.address else {
                          print("주소 복사 실패: 주소 정보 없음")
                          return nil
                      }
                      print("주소 복사됨: \(address)")
                      return address
                  }

        return Output(
            popupData: popupData,
            bookmarkToggled: bookmarkToggled,
            addressCopied: addressCopied
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

