import CoreLocation

struct PopUpStore {
    let id: Int64
    let name: String
    let categories: [String] // 여러 카테고리를 가질 수 있도록 배열로 유지
    let location: CLLocationCoordinate2D
    let address: String
    let startDate: Date
    let endDate: Date
    let markerId: Int
    let markerTitle: String
    let markerSnippet: String

    var latitude: CLLocationDegrees {
        return location.latitude
    }

    var longitude: CLLocationDegrees {
        return location.longitude
    }
}
