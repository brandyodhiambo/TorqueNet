//
//  TorqueNetApp.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI

@main
struct TorqueNetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var themesViewModel = ThemesViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var router = Router()
    @StateObject var tabRouter = TabRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(tabRouter)
                .environmentObject(themesViewModel)
                .environmentObject(settingsViewModel)
                .onAppear {
                    themesViewModel.setAppTheme()
                }
        }
    }
}
