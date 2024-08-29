import Foundation
import RxSwift
import Alamofire

protocol SearchServiceProtocol {
    func searchStores(query: String) -> Observable<[PopUpStore]>
}

class SearchService: SearchServiceProtocol {
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor

    init(provider: Provider = ProviderImpl(), tokenInterceptor: TokenInterceptor = TokenInterceptor()) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }

    func searchStores(query: String) -> Observable<[PopUpStore]> {
        let endpoint = PopPoolAPIEndPoint.search_popUpStores(query: query)

        return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
            .do(onNext: { response in
                // 디버깅용 응답 로그
                if let data = try? JSONEncoder().encode(response),
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("SearchService - 응답 데이터: \(jsonString)")
                }
            })
            .map { (response: [PopUpStoreDTO]) in
                response.map { $0.toDomain() }
            }
            .catch { error -> Observable<[PopUpStore]> in
                print("Search error: \(error)")
                if let afError = error as? AFError {
                    switch afError {
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(reason)")
                        if case .inputDataNilOrZeroLength = reason {
                            // 빈 배열 반환 또는 다른 적절한 처리
                            return .just([])
                        }
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(reason)")
                        if case .unacceptableStatusCode(let code) = reason {
                            print("Unacceptable status code: \(code)")
                            if code == 401 {
                             
                            }
                        }
                    default:
                        print("Other AFError: \(afError.localizedDescription)")
                    }
                }
                return .error(error)
            }
    }
}
