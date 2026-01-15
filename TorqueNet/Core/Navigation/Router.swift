//
//  Router.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    private var routeStack: [Route] = []
    
    /// Pushes a new route onto the navigation stack
    /// - Parameter route: The route to navigate to
    func push(_ route: Route) {
        path.append(route)
        routeStack.append(route)
    }
    
    /// Pops the last route from the stack (navigates back by one screen)
    func pop() {
        if !routeStack.isEmpty {
            path.removeLast()
            routeStack.removeLast()
        }
    }
    
    /// Pops all routes and returns to the root screen
    func popToRoot() {
        path = NavigationPath()
        routeStack.removeAll()
    }
    
    /// Replaces the current navigation stack with a single new route
    /// Useful when you don’t want the user to go back to previous screens
    /// - Parameter route: The new route to display
    func replace(with route: Route) {
        path = NavigationPath()
        routeStack = [route]
        path.append(route)
    }
    
    /// Replaces the current navigation stack with a list of routes
    /// Useful for building up a multi-step screen history programmatically
    /// - Parameter routes: A list of routes to push in order
    /// Replace the entire stack with multiple routes (e.g., after login: [.dashboard, .profile])
    func replaceStack(with routes: [Route]) {
        path = NavigationPath()
        routeStack = routes
        for route in routes {
            path.append(route)
        }
    }
    
    /// Pops routes from the stack until the first occurrence of a given route type is found
    /// Example: `popTo(HomeRoute.self)` will pop all routes above the first `HomeRoute`
    /// - Parameter routeType: The type of route to pop to
    func popTo(_ routeType: Route.Type) {
        while let last = routeStack.last, type(of: last) != routeType {
            path.removeLast()
            routeStack.removeLast()
        }
    }
    
    /// Checks whether a specific route is currently in the navigation stack
    /// - Parameter route: The route to check for
    /// - Returns: `true` if the route exists in the stack
    func contains(_ route: Route) -> Bool {
        return routeStack.contains(route)
    }
    
    /// Removes a specific route from the navigation stack if it exists
    /// After removal, it rebuilds the navigation path
    /// - Parameter route: The route to remove
    func remove(_ route: Route) {
        guard let index = routeStack.firstIndex(of: route) else { return }
        routeStack.remove(at: index)
        path = NavigationPath()
        for route in routeStack {
            path.append(route)
        }
    }
    
    /// Pops the current route and immediately pushes a new one
    /// Useful when replacing the current screen with a new one
    /// - Parameter route: The new route to navigate to
    func popThenPush(_ route: Route) {
        pop()
        push(route)
    }
    
    /// Clears the entire navigation stack
    /// Effectively resets the navigation to its initial state
    func reset() {
        path = NavigationPath()
        routeStack.removeAll()
    }
}


@ViewBuilder
func viewForRoute(_ route: Route, router: Router) -> some View{
    switch route {
        
    case .onboarding:
        OnboardingView(
            action:{}
        )
        .navigationBarBackButtonHidden()
        
    case .dashboard:
        DashboardView()
            .navigationBarBackButtonHidden()
        
    case .login:
        LoginView(
            onLoginSuccess: {},
            onLoginFailure: {_ in}
        )
        .navigationBarBackButtonHidden()
        
    case .register:
        RegisterView()
            .navigationBarBackButtonHidden()
        
    case .forgotPassword:
        ForgotPasswordView()
            .navigationBarBackButtonHidden()
        
    case .home:
        HomeView()
        
    case .carDetails(let car):
        CarDetailView(car: car)
            .navigationBarBackButtonHidden()
        
    case .uploadCar:
        CarUploadView()
            .navigationBarBackButtonHidden()
        
    case .auction:
        AuctionView()
        
    case .auctionDetails(let auction):
        AuctionCarDetailView(auction:auction)
            .navigationBarBackButtonHidden()
        
    case .auctionUpload:
        AuctionUploadView()
            .navigationBarBackButtonHidden()
        
    case .auctionLiveBids:
        LiveAuctionsView()
            .navigationBarBackButtonHidden()
        
    case .auctionSchedule:
        AuctionScheduleView()
            .navigationBarBackButtonHidden()
        
    case .wishlist:
        WishListView()
        
    case .settings:
        SettingsView()
    
    case .notification:
        NotificationsView()
            .navigationBarBackButtonHidden()
        
    case .profile:
        ProfileView()
        .navigationBarBackButtonHidden()
        
    case .changePassword:
        ChangePasswordView()
        .navigationBarBackButtonHidden()
        
    case .editProfile:
        EditProfileView()
        .navigationBarBackButtonHidden()
        
    }
}
