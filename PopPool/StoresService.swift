import Foundation
import Alamofire
import RxSwift

// 쿼리 파라미터 모델 구조체
struct BoundsQueryParameters: Encodable {
    let categories: [String]?
    let northEastLat: Double
    let northEastLon: Double
    let southWestLat: Double
    let southWestLon: Double
}

// 검색 쿼리 모델 구조체
struct SearchStoresQuery: Encodable {
    let query: String
    let category: String?
}

// 스토어 서비스 프로토콜
protocol StoresServiceProtocol {
    func getAllStores() -> Observable<[PopUpStore]>
    func searchStores(query: String) -> Observable<[PopUpStore]>
    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]>
    func getCustomPopUpStoreImages(userId: String, page: Int, size: Int) -> Observable<[PopUpStoreImage]>
}

// 스토어 서비스 클래스
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

    // 모든 스토어를 가져오는 메서드
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

    // 스토어를 검색하는 메서드
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

    // 특정 범위 내의 팝업 스토어를 가져오는 메서드
    func getPopUpStoresInBounds(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, categories: [String]?) -> Observable<[PopUpStore]> {
        print("쿼리 파라미터: Bounds - NE Lat: \(northEastLat), NE Lon: \(northEastLon), SW Lat: \(southWestLat), SW Lon: \(southWestLon)")
        print("카테고리: \(categories?.joined(separator: ",") ?? "모든 카테고리")")

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

                // Authorization 헤더 추가
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
    func getCustomPopUpStoreImages(userId: String, page: Int, size: Int) -> Observable<[PopUpStoreImage]> {
        return keyChainService.fetchToken(type: .accessToken)
            .asObservable()
            .flatMap { accessToken -> Observable<[PopUpStoreImage]> in
                let endpoint = PopPoolAPIEndPoint.home_fetchCustomPopUpStores(
                    userId: userId,
                    page: 0,
                    size: 1,
                    sort: "startDate"
                )

                // Authorization 헤더 추가
                let headers = ["Authorization": "Bearer \(accessToken)", "Accept": "*/*"]
                endpoint.headers = headers

                print("StoresService - 맞춤형 팝업 스토어 이미지 요청 URL: \(try? endpoint.url().absoluteString ?? "")")

                return self.provider.requestData(with: endpoint, interceptor: self.tokenInterceptor)
                    .do(onNext: { response in
                        print("StoresService - 맞춤형 팝업 스토어 이미지 가져오기 성공")
                    }, onError: { error in
                        print("StoresService - 맞춤형 팝업 스토어 이미지 가져오기 실패: \(error)")
                        self.logError(error)
                    })
                    .map { (response: GetCustomPopUpStoreImageResponseDTO) -> [PopUpStoreImage] in
                        return response.customPopUpStoreList                    }
            }
    }


    // Alamofire 에러 로깅 메서드
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
