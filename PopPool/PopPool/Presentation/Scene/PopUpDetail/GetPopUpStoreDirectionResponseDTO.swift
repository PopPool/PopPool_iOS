// MARK: - Directions Response DTO

struct GetPopUpStoreDirectionResponseDTO: Codable {
    let id: Int64
    let category: String
    let name: String
    let address: String
    let startDate: String
    let endDate: String
    let latitude: Double
    let longitude: Double
    let markerId: Int64
    let markerTitle: String
    let markerSnippet: String

    // 빈 객체 반환 슝
    static var empty: GetPopUpStoreDirectionResponseDTO {
        return GetPopUpStoreDirectionResponseDTO(
            id: 0,
            category: "",
            name: "",
            address: "",
            startDate: "",
            endDate: "",
            latitude: 0.0,
            longitude: 0.0,
            markerId: 0,
            markerTitle: "",
            markerSnippet: ""
        )
    }
}
