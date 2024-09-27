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
            .flatMap { response -> Observable<[SearchPopUpStoreDTO]> in
                // 1. 응답이 SearchPopUpStoreResponseDTO 타입인지 확인
                if let decodedResponse = response as? SearchPopUpStoreResponseDTO {
                    print("응답이 이미 디코딩된 상태입니다: \(decodedResponse)")
                    return .just(decodedResponse.popUpStoreList)
                } else {
                    print("응답이 SearchPopUpStoreResponseDTO 타입이 아닙니다. 타입: \(type(of: response))")
                    return .error(NSError(domain: "DataError", code: -1, userInfo: nil))
                }
            }
            .catchError { error -> Observable<[SearchPopUpStoreDTO]> in
                print("Search error: \(error)")
                return .just([])  // 에러 발생 시 빈 배열 반환
            }
    }

}
