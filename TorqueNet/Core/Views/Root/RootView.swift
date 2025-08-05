//
//  RootView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            Group{
                if LocalState.isFirstTimeUsingApp{
                    OnboardingView{
                        LocalState.isFirstTimeUsingApp = false
                    }
                }
                else if !LocalState.isFirstTimeUsingApp && !LocalState.isLoggedIn{
                    LoginView(onLoginSuccess: {
                        LocalState.isLoggedIn = true
                    }, onLoginFailure: {_ in})
                }
                else if LocalState.isLoggedIn{
                    DashboardView()
                }
            }
            .navigationDestination(for: Route.self) { route in
                viewForRoute(route, router: router)
            }
        }
    }
}

#Preview {
    RootView()
}
