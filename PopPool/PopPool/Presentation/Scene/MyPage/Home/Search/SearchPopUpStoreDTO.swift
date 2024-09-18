import Foundation

struct SearchPopUpStoreResponseDTO: Codable {
    let popUpStoreList: [SearchPopUpStoreDTO]
}

struct SearchPopUpStoreDTO: Codable {
    let id: Int64
    let name: String
    let address: String
}


extension SearchPopUpStoreDTO {
    func toPopUpStore() -> SearchPopUpStore {
        return SearchPopUpStore(
            id: id,
            name: name,
            address: address
        )
    }
}
