//
//  DatabaseError.swift
//  PopPool
//
//  Created by Porori on 6/19/24.
//

import Foundation

enum DatabaseError: Error {
    case dataConversionError(String)
    case duplicateItem(String)
    case unhandledError(status: OSStatus)
    case noValueFound(String)
    case noData(String)
}
