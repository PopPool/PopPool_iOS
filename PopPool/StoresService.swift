import Foundation
import Alamofire
import RxSwift

// Query parameters 구조체 정의
struct BoundsQueryParameters: Encodable {
    let categories: [String]?  // String에서 [String] 배열로 변경
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
    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]> // categories를 배열로 변경
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
        components?.queryItems = [
            URLQueryItem(name: "northEastLat", value: String(northEastLat)),
            URLQueryItem(name: "northEastLon", value: String(northEastLon)),
            URLQueryItem(name: "southWestLat", value: String(southWestLat)),
            URLQueryItem(name: "southWestLon", value: String(southWestLon))
        ]

        if let categories = categories {
            for category in categories {
                components?.queryItems?.append(URLQueryItem(name: "categories", value: category))

            }
        }

        guard let url = components?.url else {
            return .error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }

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
                    
                }
            })
            .map { (response: [PopUpStoreDTO]) -> [PopUpStore] in
                return response.map { $0.toDomain() }
            }
            .catch { error in
                print("StoresService - API 에러 발생: \(error)")
                return .error(error)
            }
    }
}
