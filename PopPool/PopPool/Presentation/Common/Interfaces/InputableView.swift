//
//  InputableView.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/24/24.
//

import Foundation

protocol InputableView: Inputable {
    func injectionWith(input: Input)
}
