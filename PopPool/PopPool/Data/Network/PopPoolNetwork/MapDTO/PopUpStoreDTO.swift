import Foundation
import CoreLocation

struct PopUpStoreDTO: Decodable {
    let id: Int64
    let categories: [String]
    let name: String
    let address: String
    let startDate: String
    let endDate: String  
    let latitude: Double
    let longitude: Double
    let markerId: Int
    let markerTitle: String
    let markerSnippet: String

    func toDomain() -> PopUpStore {
        let dateFormatter = ISO8601DateFormatter()
        return PopUpStore(
            id: id,
            name: name,
            categories: categories,
            location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            address: address,
            startDate: dateFormatter.date(from: startDate) ?? Date(),
            endDate: dateFormatter.date(from: endDate) ?? Date(),
            markerId: markerId,
            markerTitle: markerTitle,
            markerSnippet: markerSnippet
        )
    }
}
