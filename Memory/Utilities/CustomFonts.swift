//
//  AppFonts.swift
//  Memory
//
//  Created by Mayank Rikh on 25/01/19.
//  Copyright © 2019 Mayank Rikh. All rights reserved.
//

import Foundation
import UIKit

enum CustomFonts {

    case `default`

    func withSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize.getFontSize)
    }
}

extension CGFloat{
    var getFontSize: CGFloat{
        switch UIScreen.main.bounds.width {
        case let x where x < 321:
            return self
        case let x where x < 376:
            return self * 100/86
        default:
            return (self * 100/86) * 1.1
        }
    }
}
