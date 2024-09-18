import Foundation
import RxSwift
import Alamofire

protocol SearchServiceProtocol {
    func searchStores(query: String) -> Observable<[SearchPopUpStoreDTO]>
}

class SearchService: SearchServiceProtocol {
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor

    init(provider: Provider = ProviderImpl(), tokenInterceptor: TokenInterceptor = TokenInterceptor()) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }

    func searchStores(query: String) -> Observable<[SearchPopUpStoreDTO]> {
        let endpoint = PopPoolAPIEndPoint.searchStores(query: query)

        return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
            .do(onNext: { response in
                print("SearchService - 응답 데이터: \(response)")
            })
            .map { response in
                return response.map { dto in
                    SearchPopUpStoreDTO(id: dto.id, name: dto.name, address: dto.address)
                }
            }
            .catchError { error -> Observable<[SearchPopUpStoreDTO]> in
                print("Search error: \(error)")
                return .just([]) // 에러 발생 시 빈 배열 반환
            }
    }


}
