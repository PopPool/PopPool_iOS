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
    func searchStores(query: String, category: String?) -> Observable<[PopUpStore]>
    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]>
}

class StoresService: StoresServiceProtocol {
    private let provider: Provider
    private let tokenInterceptor: TokenInterceptor

    init(provider: Provider, tokenInterceptor: TokenInterceptor) {
        self.provider = provider
        self.tokenInterceptor = tokenInterceptor
    }

    func getAllStores() -> Observable<[PopUpStore]> {
        let endpoint = Endpoint<[PopUpStoreDTO]>(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/locations/popup-stores",
            method: .get
        )

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

    func searchStores(query: String, category: String?) -> Observable<[PopUpStore]> {
        let queryParameters = SearchStoresQuery(query: query, category: category)

        let endpoint = Endpoint<[PopUpStoreDTO]>(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/locations/search",
            method: .get,
            queryParameters: queryParameters
        )

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

        var components = URLComponents(string: Secrets.popPoolBaseUrl.rawValue + "/locations/popup-stores")
        var queryItems: [URLQueryItem] = []

        if let categories = categories {
               for category in categories {
                   queryItems.append(URLQueryItem(name: "categories", value: category))
               }
           }

        queryItems += [
            URLQueryItem(name: "northEastLat", value: String(northEastLat)),
            URLQueryItem(name: "northEastLon", value: String(northEastLon)),
            URLQueryItem(name: "southWestLat", value: String(southWestLat)),
            URLQueryItem(name: "southWestLon", value: String(southWestLon))
        ]

        components?.queryItems = queryItems

        guard let url = components?.url else {
            return .error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        let encodedUrlString = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url.absoluteString


        print("StoresService - 요청 URL: \(url.absoluteString)")

        let endpoint = Endpoint<[PopUpStoreDTO]>(
            baseURL: url.absoluteString,
            path: "",
            method: .get
        )

        return provider.requestData(with: endpoint, interceptor: tokenInterceptor)
            .do(onNext: { response in
                print("StoresService - 팝업 스토어 가져오기 성공: \(response.count) 개의 스토어")
            }, onError: { error in
                print("StoresService - 팝업 스토어 가져오기 실패: \(error)")
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
            })
            .map { (response: [PopUpStoreDTO]) -> [PopUpStore] in
                return response.map { $0.toDomain() }
            }
            .catch { error in
                print("StoresService - API 에러 발생: \(error)")
                if let afError = error as? AFError, let data = afError.underlyingError as? Data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("응답 데이터: \(responseString)")
                }
                return .error(error)
            }
    }
}
