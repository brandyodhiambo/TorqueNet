//
//  LocalState.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import Foundation
import SwiftUI

enum Keys: String{
    case isFirstTimeUsingApp
    case fontPrefix
    case theme
    case isDarkModeOn
    case isLogedIn
}

public class LocalState {
    @AppStorage(Keys.isFirstTimeUsingApp.rawValue) static var isFirstLaunch: Bool = true
    @AppStorage(Keys.isDarkModeOn.rawValue) static var isDarkModeOn: String?
    @AppStorage(Keys.isLogedIn.rawValue) static var isLogedIn: Bool = false
}
