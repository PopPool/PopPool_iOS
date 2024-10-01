import Foundation

struct PopupDetail: Codable {
    let name: String
    let desc: String
    let startDate: String
    let endDate: String
    let address: String
    let commentCount: Int
    let bookmarkYn: Bool
    let loginYn: Bool
    let mainImageUrl: String
    let imageList: [ImageInfo]
    let commentList: [Comment]
    let similarPopUpStoreList: [SimilarPopUp]

    func formattedStartDate() -> String {
        return PopupDetail.formatDate(from: startDate)
    }

    func formattedEndDate() -> String {
        return PopupDetail.formatDate(from: endDate)
    }

    // 메서드를 internal로 변경
    static func formatDate(from dateString: String) -> String {
        if let date = PopupDetail.inputDateFormatter.date(from: dateString) {
            return PopupDetail.outputDateFormatter.string(from: date)
        }
        return dateString
    }

    private static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    private static let outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"
        return formatter
    }()
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
    let endDate: String

    func formattedEndDate() -> String {
        return PopupDetail.formatDate(from: endDate)
    }
}

extension PopupDetail {
    static let empty = PopupDetail(
        name: "",
        desc: "",
        startDate: "",
        endDate: "",
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
