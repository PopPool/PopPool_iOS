import Foundation

struct PopupDetail: Codable {
    let name: String
    let desc: String
    let startDate: Date
    let endDate: Date
    let address: String
    let commentCount: Int
    let bookmarkYn: Bool
    let loginYn: Bool
    let mainImageUrl: String
    let imageList: [ImageInfo]
    let commentList: [Comment]
    let similarPopUpStoreList: [SimilarPopUp]
}

struct ImageInfo: Codable {
    let id: Int
    let imageUrl: String
}

struct Comment: Codable {
    let nickname: String
    let instagramId: String?
    let profileImageUrl: String
    let content: String
    let likeYn: Bool
    let likeCount: Int
    let createDateTime: Date
    let commentImageList: [ImageInfo]
}

struct SimilarPopUp: Codable {
    let id: Int
    let name: String
    let mainImageUrl: String
    let endDate: Date
}


extension PopupDetail {
    static let empty = PopupDetail(
        name: "",
        desc: "",
        startDate: Date(),
        endDate: Date(),
        address: "",
        commentCount: 0,
        bookmarkYn: false,
        loginYn: false,
        mainImageUrl: "",
        imageList: [],
        commentList: [],
        similarPopUpStoreList: []
    )
}
