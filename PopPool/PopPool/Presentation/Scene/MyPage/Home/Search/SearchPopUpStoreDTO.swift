import Foundation

struct SearchPopUpStoreResponseDTO: Codable {
    let popUpStoreList: [SearchPopUpStoreDTO] // 서버에서 받은 데이터가 딕셔너리 내부에 배열로 존재하는 경우
}

struct SearchPopUpStoreDTO: Codable {
    let id: Int64
    let name: String
    let address: String
}
