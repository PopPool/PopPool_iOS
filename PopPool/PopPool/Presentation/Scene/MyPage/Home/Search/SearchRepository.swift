import RxSwift

protocol SearchRepositoryProtocol {
    func searchStores(query: String) -> Observable<[SearchPopUpStore]>
    

}

class SearchRepository: SearchRepositoryProtocol {
    private let searchService: SearchServiceProtocol

    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }

    func searchStores(query: String) -> Observable<[SearchPopUpStore]> {
        return searchService.searchStores(query: query)
            .map { dtoList in
                dtoList.map { dto in

                    return SearchPopUpStore(id: dto.id, name: dto.name, address: dto.address)
                }
            }
    }
}
