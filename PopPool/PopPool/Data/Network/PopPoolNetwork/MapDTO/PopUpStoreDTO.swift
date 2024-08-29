import Foundation
import CoreLocation


struct PopUpStoreDTO: Codable {
    let id: Int64
    let category: String
    let name: String
    let address: String
    let startDate: String  // ISO 8601 형식의 날짜 문자열
    let endDate: String    // ISO 8601 형식의 날짜 문자열
    let latitude: Double
    let longitude: Double
    let markerId: Int
    let markerTitle: String
    let markerSnippet: String

    func toDomain() -> PopUpStore {
        return PopUpStore(
            id: id,
            category: category,
            name: name,
            address: address,
            startDate: startDate,
            endDate: endDate,
            latitude: latitude,
            longitude: longitude,
            markerId: markerId,
            markerTitle: markerTitle,
            markerSnippet: markerSnippet
        )
    }
}
struct GetViewBoundPopUpStoreListResponse: Decodable {
    var popUpStoreList: [PopUpStoreDTO]
}
