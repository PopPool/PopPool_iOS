import CoreLocation

struct PopUpStore: Decodable {
    var id: Int64
    var category: String
    var name: String
    var address: String
    var startDate: String
    var endDate: String
    var latitude: Double
    var longitude: Double
    var markerId: Int64
    var markerTitle: String
    var markerSnippet: String

}
//
//struct GetViewBoundPopUpStoreListResponse: Decodable { 
//    var popUpStoreList: [PopUpStore]
//}
