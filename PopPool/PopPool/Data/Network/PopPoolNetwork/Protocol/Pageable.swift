//
//  Pageable.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/23/24.
//

import Foundation

protocol Pageable {
    var page: Int32 { get set }
    var size: Int32 { get set }
    var sort: [String]? { get set }
}

