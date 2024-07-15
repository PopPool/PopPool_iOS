//
//  Cellable.swift
//  PopPool
//
//  Created by SeoJunYoung on 7/15/24.
//

import Foundation

protocol CellInputable: Inputable {
    func injectionWith(input: Input)
}

protocol CellOutputable: Outputable {
    func getOutput() -> Output
}

protocol Cellable: CellInputable, CellOutputable { }
