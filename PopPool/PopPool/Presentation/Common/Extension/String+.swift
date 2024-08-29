//
//  String+.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

extension String {
    func asDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = .init(identifier: "ko_KR")
        guard let date = dateFormatter.date(from: self) else {
            print("Date Convert Fail")
            return .now
        }
        return date
    }
}
