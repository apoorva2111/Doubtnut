//
//  ThemeManager.swift
//  DoubtNut
//
//  Created by Apoorva Gangrade on 13/03/21.
//

import Foundation
import UIKit

enum Theme: Int {
    
    case light, dark
  
    var white: UIColor {
        switch self {
        case .light:
            return UIColor.colorFromHex(rgbValue: 0xFFFFFF)
        case .dark:
            return UIColor.colorFromHex(rgbValue: 0xFFFFFF)
        }
    }

    var black: UIColor {
        switch self {
        case .light:
            return UIColor.colorFromHex(rgbValue: 0x000000)
        case .dark:
            return UIColor.colorFromHex(rgbValue: 0x000000)
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .default
        }
    }
}
// Enum declaration
let SelectedThemeKey = "SelectedTheme"

class ThemeManager {
    // ThemeManager

    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .light
        }
    }
}

