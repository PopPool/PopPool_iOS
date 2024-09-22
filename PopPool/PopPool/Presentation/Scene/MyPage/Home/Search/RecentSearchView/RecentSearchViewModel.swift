import Foundation
import RxSwift
import RxCocoa

class RecentSearchesViewModel {

    struct Input {
        let addSearchQuery: AnyObserver<String>
        let removeSearchQuery: AnyObserver<String>
        let removeAllSearches: AnyObserver<Void> // 추가: 모두 삭제
    }

    struct Output {
        let recentSearches: Observable<[String]>
    }

    private let addSearchQuerySubject = PublishSubject<String>()
    private let removeSearchQuerySubject = PublishSubject<String>()
    private let removeAllSearchesSubject = PublishSubject<Void>() // 추가
    private let recentSearchesSubject = BehaviorSubject<[String]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        // 추가된 검색어를 저장
        addSearchQuerySubject
            .subscribe(onNext: { [weak self] query in
                self?.addRecentSearch(query: query)
            })
            .disposed(by: disposeBag)

        // 삭제된 검색어를 반영
        removeSearchQuerySubject
            .subscribe(onNext: { [weak self] query in
                self?.removeRecentSearch(query: query)
            })
            .disposed(by: disposeBag)

        // 모두 삭제
        removeAllSearchesSubject
            .subscribe(onNext: { [weak self] in
                self?.removeAllRecentSearches()
            })
            .disposed(by: disposeBag)

        // 초기 검색어 로드
        loadRecentSearches()
    }

    var input: Input {
        return Input(addSearchQuery: addSearchQuerySubject.asObserver(),
                     removeSearchQuery: removeSearchQuerySubject.asObserver(),
                     removeAllSearches: removeAllSearchesSubject.asObserver()) // 추가
    }

    var output: Output {
        return Output(recentSearches: recentSearchesSubject.asObservable())
    }

    private func loadRecentSearches() {
        let searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        recentSearchesSubject.onNext(searches)
    }

    private func addRecentSearch(query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []

        // 중복 검색어 제거 후 리스트 업데이트
        if let index = searches.firstIndex(of: query) {
            searches.remove(at: index)
        }
        searches.insert(query, at: 0)

        // 검색어 10개로 제한
        if searches.count > 10 {
            searches.removeLast()
        }

        UserDefaults.standard.set(searches, forKey: "recentSearches")
        recentSearchesSubject.onNext(searches)
    }

    private func removeRecentSearch(query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []

        if let index = searches.firstIndex(of: query) {
            searches.remove(at: index)
        }

        UserDefaults.standard.set(searches, forKey: "recentSearches")
        recentSearchesSubject.onNext(searches)
    }

    private func removeAllRecentSearches() {
        UserDefaults.standard.set([], forKey: "recentSearches")
        recentSearchesSubject.onNext([])
    }
}
