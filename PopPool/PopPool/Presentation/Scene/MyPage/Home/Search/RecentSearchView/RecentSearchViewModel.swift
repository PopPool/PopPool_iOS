import Foundation
import RxSwift
import RxCocoa

class RecentSearchesViewModel {

    struct Input {
        let addSearchQuery: AnyObserver<String>
        let removeSearchQuery: AnyObserver<String>
        let removeAllSearches: AnyObserver<Void>
    }

    struct Output {
        let recentSearches: Observable<[String]>
    }

    private let addSearchQuerySubject = PublishSubject<String>()
    private let removeSearchQuerySubject = PublishSubject<String>()
    private let removeAllSearchesSubject = PublishSubject<Void>()
    private let recentSearchesSubject = BehaviorSubject<[String]>(value: [])

    private let disposeBag = DisposeBag()

    init() {
        // 검색어 추가 처리
        addSearchQuerySubject
            .subscribe(onNext: { [weak self] query in
                self?.addRecentSearch(query: query)
            })
            .disposed(by: disposeBag)

        // 검색어 삭제 처리
        removeSearchQuerySubject
            .subscribe(onNext: { [weak self] query in
                self?.removeRecentSearch(query: query)
            })
            .disposed(by: disposeBag)

        // 모든 검색어 삭제 처리
        removeAllSearchesSubject
            .subscribe(onNext: { [weak self] in
                self?.removeAllRecentSearches()
            })
            .disposed(by: disposeBag)

        loadRecentSearches()
    }

    var input: Input {
        return Input(addSearchQuery: addSearchQuerySubject.asObserver(),
                     removeSearchQuery: removeSearchQuerySubject.asObserver(),
                     removeAllSearches: removeAllSearchesSubject.asObserver())
    }

    var output: Output {
        return Output(recentSearches: recentSearchesSubject.asObservable())
    }

    // 최근 검색어 로드
    private func loadRecentSearches() {
        let searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        recentSearchesSubject.onNext(searches)
    }

    // 최근 검색어 추가
    private func addRecentSearch(query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []

        // 중복 검색어가 있으면 삭제
        if let index = searches.firstIndex(of: query) {
            searches.remove(at: index)
        }
        // 새로운 검색어 추가
        searches.insert(query, at: 0)

        // 검색어 10개 제한
        if searches.count > 10 {
            searches.removeLast()
        }

        // UserDefaults에 저장 및 BehaviorSubject 업데이트
        UserDefaults.standard.set(searches, forKey: "recentSearches")
        UserDefaults.standard.synchronize() // 동기화
        recentSearchesSubject.onNext(searches)
    }

    // 특정 검색어 삭제
    private func removeRecentSearch(query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []

        if let index = searches.firstIndex(of: query) {
            searches.remove(at: index)
        }

        UserDefaults.standard.set(searches, forKey: "recentSearches")
        UserDefaults.standard.synchronize() 
        recentSearchesSubject.onNext(searches)
    }

    // 모든 검색어 삭제
    private func removeAllRecentSearches() {
        UserDefaults.standard.set([], forKey: "recentSearches")
        UserDefaults.standard.synchronize()
        recentSearchesSubject.onNext([])
    }
}
