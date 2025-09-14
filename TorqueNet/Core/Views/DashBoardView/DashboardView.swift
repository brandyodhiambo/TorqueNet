//
//  DashboardView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct DashboardView: View {
    @State var isDashboardBottomNavigationVisible : Bool = true
    @State var isKeyboardVisible : Bool = false
    @EnvironmentObject var tabRouter: TabRouter
    
    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            HomeView()
                .tabItem { Label(TabItem.home.title, systemImage: TabItem.home.icon)}
                .tag(TabItem.home)
            
            AuctionView()
                .tabItem { Label(TabItem.auction.title, systemImage: TabItem.auction.icon)}
                .tag(TabItem.auction)
            
            WishListView()
                .tabItem { Label(TabItem.wishlist.title, systemImage: TabItem.wishlist.icon)}
                .tag(TabItem.wishlist)
            
            SettingsView()
                .tabItem { Label(TabItem.settings.title, systemImage: TabItem.settings.icon)}
                .tag(TabItem.settings)
        }
        .accentColor(Color.theme.primaryColor)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            let primaryUIColor = UIColor(Color.theme.primaryColor)
            appearance.stackedLayoutAppearance.selected.iconColor = primaryUIColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: primaryUIColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}


#Preview {
    DashboardView()
        .environmentObject(TabRouter())
}
