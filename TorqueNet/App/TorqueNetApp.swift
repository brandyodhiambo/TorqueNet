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
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(Router())
                .environmentObject(TabRouter())
                .environmentObject(themesViewModel)
                .onAppear {
                    themesViewModel.setAppTheme()
                }
        }
    }
}
