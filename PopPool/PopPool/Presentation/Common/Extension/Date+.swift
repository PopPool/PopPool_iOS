//
//  Date+.swift
//  PopPool
//
//  Created by SeoJunYoung on 8/24/24.
//

import Foundation

extension Date {
    func asString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = .init(identifier: "ko_KR")
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
