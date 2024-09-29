import Foundation
import RxSwift
import RxCocoa

enum SearchState {
    case initial
    case searching
    case results
}

class SearchViewModel {
    struct Input {
        let searchQuery: AnyObserver<String>
        let cancelSearch: AnyObserver<Void>
    }

    struct Output {
        let searchResults: Observable<[SearchPopUpStore]>
        let isEmptyResult: Observable<Bool>
        let realTimeSuggestions: Observable<[SearchPopUpStore]>
        let isLoading: Observable<Bool>
        let searchState: Observable<SearchState>

    }

    let input: Input
    let output: Output

    private let searchQuerySubject = BehaviorSubject<String>(value: "")
    private let cancelSearchSubject = PublishSubject<Void>()
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private let searchStateSubject = BehaviorSubject<SearchState>(value: .initial)

    private let disposeBag = DisposeBag()

    init(searchUseCase: SearchUseCaseProtocol, recentSearchesViewModel: RecentSearchesViewModel) {
        let searchResults = searchQuerySubject
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[SearchPopUpStore]> in
                if query.isEmpty {
                    print("검색어가 비어있습니다.")
                    return .just([])
                }
                print("검색어로 검색 실행: \(query)")
                return searchUseCase.searchStores(query: query)
                    .catch { error in
                        print("검색 실패: \(error.localizedDescription)")
                        return .just([])
                    }
            }
            .share(replay: 1)


        let realTimeSuggestions = searchQuerySubject
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[SearchPopUpStore]> in
                if query.isEmpty {
                    return .just([])
                }
                return searchUseCase.searchStores(query: query)
                    .catch { _ in .just([]) }
            }
            .share(replay: 1)

        let isEmptyResult = searchResults.map { $0.isEmpty }

        // 2. input과 output을 **초기화하기 전**에 모든 Observable 정의 완료
        self.input = Input(
            searchQuery: searchQuerySubject.asObserver(),
            cancelSearch: cancelSearchSubject.asObserver()
        )

        self.output = Output(
            searchResults: searchResults,
            isEmptyResult: isEmptyResult,
            realTimeSuggestions: realTimeSuggestions,
            isLoading: isLoadingSubject.asObservable(),
            searchState: searchStateSubject.asObservable()

        )

        searchResults
            .do(onSubscribe: { [weak self] in
                self?.isLoadingSubject.onNext(true)
            }, onDispose: { [weak self] in
                self?.isLoadingSubject.onNext(false)
            })
            .subscribe()
            .disposed(by: disposeBag)

        // 4. 검색 취소 처리
        cancelSearchSubject
            .subscribe(onNext: { [weak self] in
                self?.searchQuerySubject.onNext("")
                self?.isLoadingSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
