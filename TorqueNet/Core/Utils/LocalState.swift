//
//  LocalState.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import Foundation
import SwiftUI

enum Keys: String{
    case isFirstTimeUsingApp
    case isDarkModeOn
    case isLoggedIn
    case isLogout
}

public class LocalState {
    @AppStorage(Keys.isFirstTimeUsingApp.rawValue) static var isFirstTimeUsingApp: Bool = true
    @AppStorage(Keys.isDarkModeOn.rawValue) static var isDarkModeOn: String?
    @AppStorage(Keys.isLoggedIn.rawValue) static var isLoggedIn: Bool = false
    @AppStorage(Keys.isLogout.rawValue) static var isLogout: Bool = false
}
