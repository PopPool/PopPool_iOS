import Foundation

struct PopupDetail: Codable {
    let name: String
    let desc: String
    let startDate: String
    let endDate: String
    let address: String
    let commentCount: Int
    var bookmarkYn: Bool
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
    let profileImageUrl: String?
    let content: String
    let likeYn: Bool
    let likeCount: Int
    let createDateTime: String
    let commentImageList: [ImageInfo]?
    
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
//extension PopupDetail {
//    static let dummyData = PopupDetail(
//        name: "더미 팝업 스토어",
//        desc: "이것은 더미 팝업 스토어의 설명입니다. 긴 설명을 위해 여러 줄의 텍스트를 추가합니다. 더보기 버튼 테스트를 위해 충분히 길게 작성합니다. 팝업 스토어에서는 다양한 제품과 체험을 제공하며, 방문객들에게 특별한 경험을 선사합니다.",
//        startDate: "2024-07-01T00:00:00",
//        endDate: "2024-07-31T23:59:59",
//        address: "서울특별시 강남구 테헤란로 123",
//        commentCount: 5,
//        bookmarkYn: false,
//        loginYn: true,
//        mainImageUrl: "defaultImage",
//        imageList: [
//            ImageInfo(id: 1, imageUrl: "defaultImage"),
//            ImageInfo(id: 2, imageUrl: "defaultImage"),
//            ImageInfo(id: 3, imageUrl: "defaultImage")
//        ],
////        commentList: [
////            Comment(
////                nickname: "사용자1",
////                instagramId: "user1",
////                profileImageUrl: "defaultProfileImage",
////                content: "좋은 팝업 스토어네요! 제품들이 정말 멋있어요. 특히 한정판 상품들이 눈에 띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다띄었습니다."
////                // 직원분들도 친절하고 매장 분위기도 좋았어요.",
////                ,
////                likeYn: false,
////                likeCount: 15,
////                createDateTime: String(),
////                commentImageList: [
////                    ImageInfo(id: 4, imageUrl: "defaultImage"),
////                    ImageInfo(id: 5, imageUrl: "defaultImage")
////                ]
////            ),
////            Comment(
////                nickname: "사용자2",
////                instagramId: "fashionista",
////                profileImageUrl: "defaultImage",
////                content: "재미있는 경험이었어요. 다음에 또 방문하고 싶습니다. 인테리어가 독특해서 인스타 감성 사진 찍기 좋았어요! 친구들이랑 와서 즐겁게 구경했습니다.",
////                likeYn: true,
////                likeCount: 23,
////                createDateTime: String().addingTimeInterval(-86400), // 1일 전
////                commentImageList: [ImageInfo(id: 6, imageUrl: "defaultImage")]
////            ),
////            Comment(
////                nickname: "팝업러버",
////                instagramId: nil,
////                profileImageUrl: "defaultImage",
////                content: "이번 팝업 컨셉이 너무 좋았어요. 브랜드의 아이덴티티가 잘 드러나는 공간 구성이었고, 체험 코너도 재밌었습니다. 다만 사람이 너무 많아서 좀 붐비는 느낌이었어요느낌이었어요느낌이었어요느낌이었어요느낌이었어요느낌이었어요느낌이었어요느낌이었어요.",
////                likeYn: false,
////                likeCount: 7,
////                createDateTime: String().addingTimeInterval(-172800), // 2일 전
////                commentImageList: []
////            ),
////            Comment(
////                nickname: "스타일리시",
////                instagramId: "stylelover",
////                profileImageUrl: "defaultImage",
////                content: "제품 퀄리티가 정말 좋았어요. 평소에 온라인에서만 보던 제품들을 실제로 보고 만져볼 수 있어서 좋았습니다. 가격대가 조금 높은 편이지만 그만한 가치가 있다고 생각해요.",
////                likeYn: true,
////                likeCount: 19,
////                createDateTime: String().addingTimeInterval(-259200), // 3일 전
////                commentImageList: [
////                    ImageInfo(id: 7, imageUrl: "defaultImage"),
////                    ImageInfo(id: 8, imageUrl: "defaultImage"),
////                    ImageInfo(id: 9, imageUrl: "defaultImage")
////                ]
////            ),
////            Comment(
////                nickname: "팝업매니아",
////                instagramId: "popupmania",
////                profileImageUrl: "defaultProfileImage",
////                content: "여러 팝업 스토어를 다녀봤지만 이번엔 특별했어요. 브랜드 스토리를 잘 풀어낸 것 같아요. 직원분들의 상품 설명도 상세해서 좋았습니다. 다음 팝업도 기대되네요!",
////                likeYn: false,
////                likeCount: 11,
////                createDateTime: String().addingTimeInterval(-345600), // 4일 전
////                commentImageList: [ImageInfo(id: 10, imageUrl: "defaultImage")]
////            )
////        ],
////        similarPopUpStoreList: [
////            SimilarPopUp(id: 2, name: "유사 팝업1", mainImageUrl: "defaultImage", endDate: "2024-08-15T23:59:59"),
////            SimilarPopUp(id: 3, name: "유사 팝업2", mainImageUrl: "defaultImage", endDate: "2024-08-20T23:59:59")
////        ]
////    )
////}
