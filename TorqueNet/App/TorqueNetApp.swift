//
//  TorqueNetApp.swift
//  TorqueNet
//
//  Created by MAC on 04/08/2025.
//

import SwiftUI

@main
struct TorqueNetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
