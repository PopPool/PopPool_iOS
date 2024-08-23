import Foundation
import RxSwift

struct PopUpStoreQueryParameters: Encodable {
    let northEastLat: Double
    let northEastLon: Double
    let southWestLat: Double
    let southWestLon: Double
    let category: String?
}

final class MapRepositoryImpl: MapRepository {
    private let provider: Provider

    init(provider: Provider) {
        self.provider = provider
    }

    func fetchPopUpStores(northEastLat: Double, northEastLon: Double, southWestLat: Double, southWestLon: Double, category: String?) -> Observable<[PopUpStore]> {
        let queryParameters = PopUpStoreQueryParameters(
            northEastLat: northEastLat,
            northEastLon: northEastLon,
            southWestLat: southWestLat,
            southWestLon: southWestLon,
            category: category
        )

        let endpoint = Endpoint<[PopUpStoreDTO]>(
            baseURL: Secrets.popPoolBaseUrl.rawValue,
            path: "/locations/popup-stores",
            method: .get,
            queryParameters: queryParameters
        )

        return provider.requestData(with: endpoint)
            .map { response in
                response.map { $0.toDomain() }
            }
            .catch { error in
                return .error(error)
            }
    }
}
