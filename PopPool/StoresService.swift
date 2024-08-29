import Foundation
import Alamofire
import RxSwift

struct BoundsQueryParameters: Encodable {
    let categories: [String]?
    let northEastLat: Double
    let northEastLon: Double
    let southWestLat: Double
    let southWestLon: Double
}

struct SearchStoresQuery: Encodable {
    let query: String
    let category: String?
}

protocol StoresServiceProtocol {
    func getAllStores() -> Observable<[PopUpStore]>
    func searchStores(query: String) -> Observable<[PopUpStore]>
    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]>
}

class StoresService: StoresServiceProtocol {
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor
    private let keyChainService: KeyChainService
    private var disposeBag = DisposeBag()

    init(provider: Provider, tokenInterceptor: TokenInterceptor, keyChainService: KeyChainService) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
        self.keyChainService = keyChainService
    }

    func getAllStores() -> Observable<[PopUpStore]> {
        let endpoint = PopPoolAPIEndPoint.getAllStores()

        return provider.requestData(with: endpoint)
            .do(onNext: { response in
                print("getAllStores 성공: \(response.count) 개의 스토어")
            }, onError: { error in
                print("getAllStores 실패: \(error)")
            })
            .map { response in
                response.map { $0.toDomain() }
            }
            .catch { error in
                print("API 에러 발생: \(error)")
                return .error(error)
            }
    }

    func searchStores(query: String) -> Observable<[PopUpStore]> {
        let endpoint = PopPoolAPIEndPoint.searchStores(query: query)

        return provider.requestData(with: endpoint)
            .do(onNext: { response in
                print("searchStores 성공: \(response.count) 개의 스토어")
            }, onError: { error in
                print("searchStores 실패: \(error)")
            })
            .map { response in
                response.map { $0.toDomain() }
            }
            .catch { error in
                print("API 에러 발생: \(error)")
                return .error(error)
            }
    }

    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]> {
        print("StoresService - 팝업 스토어 요청 시작")

        return keyChainService.fetchToken(type: .accessToken)
            .asObservable()
            .flatMap { accessToken -> Observable<[PopUpStore]> in
                var endpoint = PopPoolAPIEndPoint.getPopUpStoresInBounds(
                    northEastLat: northEastLat,
                    northEastLon: northEastLon,
                    southWestLat: southWestLat,
                    southWestLon: southWestLon,
                    categories: categories
                )

                let headers = ["Authorization": "Bearer \(accessToken)", "Accept": "*/*"]
                endpoint.headers = headers

                print("StoresService - 요청 URL: \(try? endpoint.url().absoluteString ?? "")")

                return self.provider.requestData(with: endpoint, interceptor: self.tokenInterceptor)
                    .do(onNext: { response in
                        print("StoresService - 팝업 스토어 가져오기 성공: \(response.popUpStoreList.count) 개의 스토어")
                    }, onError: { error in
                        print("StoresService - 팝업 스토어 가져오기 실패: \(error)")
                        self.logError(error)
                    })
                    .map { responseDTO in
                        responseDTO.popUpStoreList.map { $0.toDomain() }
                    }
            }
    }

    private func logError(_ error: Error) {
        if let afError = error as? AFError {
            print("StoresService - Alamofire 에러 상세: \(afError.errorDescription ?? "알 수 없음")")
            switch afError {
            case .responseValidationFailed(let reason):
                print("응답 검증 실패: \(reason)")
                if case .unacceptableStatusCode(let code) = reason {
                    print("상태 코드: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("응답 직렬화 실패: \(reason)")
                if case .inputDataNilOrZeroLength = reason {
                    print("응답 데이터가 없거나 길이가 0입니다.")
                }
            case .sessionTaskFailed(let error):
                if let urlError = error as? URLError {
                    print("URL 에러: \(urlError.localizedDescription)")
                } else {
                    print("세션 태스크 실패: \(error.localizedDescription)")
                }
            default:
                print("기타 Alamofire 에러")
            }
        }
    }
}
