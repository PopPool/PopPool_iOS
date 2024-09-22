// CategoryUtility.swift

import Foundation

class CategoryUtility {
    static let shared = CategoryUtility()

    private init() {}

    let categoryMapping: [String: String] = [
        "패션": "FASHION",
        "라이프스타일": "LIFESTYLE",
        "뷰티": "BEAUTY",
        "음식/요리": "FOOD",
        "예술": "ART",
        "반려동물": "PETS",
        "여행": "TRAVEL",
        "엔터테인먼트": "ENTERTAINMENT",
        "애니메이션": "ANIMATION",
        "키즈": "KIDS",
        "스포츠": "SPORTS",
        "게임": "GAME"
    ]

    func toEnglishCategory(_ koreanCategory: String) -> String {
        return categoryMapping[koreanCategory] ?? koreanCategory
    }

    func toKoreanCategory(_ englishCategory: String) -> String {
        return categoryMapping.first(where: { $0.value == englishCategory })?.key ?? englishCategory
    }
}
