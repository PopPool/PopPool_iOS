import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    struct Input {
        let searchQuery: AnyObserver<String>
        let cancelSearch: AnyObserver<Void>
    }

    struct Output {
        let searchResults: Observable<[SearchPopUpStore]>
        let isEmptyResult: Observable<Bool>

    }

    let input: Input
    let output: Output

    private let searchQuerySubject = BehaviorSubject<String>(value: "")
    private let cancelSearchSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    init(searchUseCase: SearchUseCaseProtocol, recentSearchesViewModel: RecentSearchesViewModel) {
        let searchResults: Observable<[SearchPopUpStore]> = searchQuerySubject
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { query -> Observable<[SearchPopUpStore]> in
                guard !query.isEmpty else { return .just([]) }
                // 검색어 저장
                recentSearchesViewModel.input.addSearchQuery.onNext(query)
                return searchUseCase.searchStores(query: query)

            }
            .share(replay: 1)

        let isEmptyResult = searchResults.map { $0.isEmpty }


        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            cancelSearch: cancelSearchSubject.asObserver()
        )

        self.output = Output(
            searchResults: searchResults,
            isEmptyResult: isEmptyResult
        )


        cancelSearchSubject
            .subscribe(onNext: { [weak self] in
                self?.searchQuerySubject.onNext("")
            })
            .disposed(by: disposeBag)
    }
}
