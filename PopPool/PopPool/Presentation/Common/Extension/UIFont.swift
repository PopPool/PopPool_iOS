//
//  UIFont.swift
//  PopPool
//
//  Created by Porori on 6/20/24.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Size: CGFloat {
        case _11 = 11
        case _12 = 12
        case _13 = 13
        case _14 = 14
        case _15 = 15
        case _16 = 16
        case _18 = 18
        case _20 = 20
        case _24 = 24
        case _28 = 28
        case _32 = 32
    }
    
    enum EngFont {
        case regular(size: Size)
        case light(size: Size)
        case medium(size: Size)
        case bold(size: Size)
        
        var name: UIFont! {
            switch self {
            case .bold(let size): return UIFont(name: "Poppins-Bold", size: size.rawValue)
            case .light(let size): return UIFont(name: "Poppins-Light", size: size.rawValue)
            case .medium(let size): return UIFont(name: "Poppins-Medium", size: size.rawValue)
            case .regular(let size): return UIFont(name: "Poppins-Regular", size: size.rawValue)
            }
        }
    }
    
    enum KorFont {
        case regular(size: Size)
        case light(size: Size)
        case medium(size: Size)
        case bold(size: Size)
        
        var name: UIFont! {
            switch self {
            case .bold(let size): return UIFont(name: "GothicA1-Bold", size: size.rawValue)
            case .light(let size): return UIFont(name: "GothicA1-Light", size: size.rawValue)
            case .medium(let size): return UIFont(name: "GothicA1-Medium", size: size.rawValue)
            case .regular(let size): return UIFont(name: "GothicA1-Regular", size: size.rawValue)
            }
        }
    }
}

