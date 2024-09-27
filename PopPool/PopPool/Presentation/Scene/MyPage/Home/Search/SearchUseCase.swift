import RxSwift

protocol SearchUseCaseProtocol {
    func searchStores(query: String) -> Observable<[SearchPopUpStore]>
    
}

class SearchUseCase: SearchUseCaseProtocol {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func searchStores(query: String) -> Observable<[SearchPopUpStore]> {
        return repository.searchStores(query: query)
    }
}
