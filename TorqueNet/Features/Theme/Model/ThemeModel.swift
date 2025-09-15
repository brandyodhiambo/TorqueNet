//
//  ThemeModel.swift
//  Majira
//
//  Created by Brandy Odhiambo on 09/07/2025.
//

import Foundation

import SwiftUI

enum ThemeModel: String, CaseIterable, Identifiable {
    case device, light, dark

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .device: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var themName: String {
        switch self {
        case .device:
            "System"
        case .light:
            "Light"
        case .dark:
            "Dark"
        }
    }
    
    init(isDarkModeOn: Bool?) {
        switch isDarkModeOn {
        case true: self = .dark
        case false: self = .light
        default: self = .device
        }
    }
    
    var id: String{ rawValue}
}
