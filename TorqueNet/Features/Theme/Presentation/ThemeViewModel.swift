//
//  ThemeViewModel.swift
//  Majira
//
//  Created by Brandy Odhiambo on 09/07/2025.
//

import Foundation
import SwiftUI

class ThemesViewModel: ObservableObject{
    @Published var currentTheme: ThemeModel = .device

    func changeTheme(to theme: ThemeModel) {
        LocalState.isDarkModeOn = "\(theme == .dark)"
        currentTheme = theme
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = theme.userInterfaceStyle
        print("Debug: isDarkModeOn \(LocalState.isDarkModeOn ?? "")")
    }
    
    func setAppTheme() {
        var isDarkModeOn: Bool
        let savedThemeIsDarkModeOn: String? = LocalState.isDarkModeOn
        
        if savedThemeIsDarkModeOn == "true" {
            isDarkModeOn = true
        }
        else if savedThemeIsDarkModeOn == "false"{
            isDarkModeOn = false
        }
        else {
            let systemStyle = UIScreen.main.traitCollection.userInterfaceStyle
            isDarkModeOn = systemStyle == .dark ? true : false
            print("DEBUG: systemStyle \(systemStyle), isDarkModeOn \(isDarkModeOn)")
        }
        
        currentTheme = ThemeModel(isDarkModeOn: isDarkModeOn)
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
        print("DEBUG: currentTheme \(currentTheme.themName)")
    }
}
