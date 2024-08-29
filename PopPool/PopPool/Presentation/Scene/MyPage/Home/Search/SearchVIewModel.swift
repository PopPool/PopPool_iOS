import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    struct Input {
        let searchQuery: AnyObserver<String>
        let cancelSearch: AnyObserver<Void>
    }

    struct Output {
        let recentSearches: Observable<[String]>
        let searchResults: Observable<[PopUpStore]>
        let isEmptyResult: Observable<Bool>
        let isSearching: Observable<Bool>
    }

    let input: Input
    let output: Output

    private let searchQuerySubject = BehaviorSubject<String>(value: "")
    private let cancelSearchSubject = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    init(searchService: SearchServiceProtocol = SearchService()) {
        let recentSearches = Observable.just(["패션", "뷰티", "식품"]) // 실제로는 로컬 저장소에서 가져와야 함

        let searchResults = searchQuerySubject
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { query -> Observable<[PopUpStore]> in
                guard !query.isEmpty else { return .just([]) }
                return searchService.searchStores(query: query)
            }
            .share(replay: 1)

        let isEmptyResult = searchResults.map { $0.isEmpty }
        let isSearching = searchQuerySubject.map { !$0.isEmpty }

        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            cancelSearch: cancelSearchSubject.asObserver()
        )

        self.output = Output(
            recentSearches: recentSearches,
            searchResults: searchResults,
            isEmptyResult: isEmptyResult,
            isSearching: isSearching
        )

        // 검색 취소 시 검색어 초기화
        cancelSearchSubject
            .subscribe(onNext: { [weak self] in
                self?.searchQuerySubject.onNext("")
            })
            .disposed(by: disposeBag)
    }
}
