//
//  DashboardView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct DashboardView: View {
       @State var isDashboardBottomNavigationVisible : Bool = true
       @State var isKeyboardVisible : Bool = false
       @EnvironmentObject var tabRouter: TabRouter
       @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $tabRouter.selectedTab) {
                TabNavigationView(router: router) {
                    HomeView()
                }.tag(TabItem.home)
                
                TabNavigationView(router: router) {
                    AuctionView()
                }.tag(TabItem.auction)
                
                TabNavigationView(router: router) {
                    WishListView()
                }.tag(TabItem.wishlist)
                
                TabNavigationView(router: router) {
                    SettingsView()
                }.tag(TabItem.settings)
            
            }

            if isDashboardBottomNavigationVisible && !isKeyboardVisible {
                ZStack {
                    HStack(spacing: 0) {
                        ForEach(TabItem.allCases, id: \.self) { item in
                            if item == .auction {
                                Spacer(minLength: 0)
                            }
                            Button {
                                tabRouter.selectedTab = item
                            } label: {
                                MyCustomTab(
                                    image: item.icon,
                                    title: item.title,
                                    isSelected: (tabRouter.selectedTab == item),
                                    bgColor: item.color
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(Color.theme.onSurfaceColor.opacity(0.1))
                }
            }
        }
        .background(Color.theme.surfaceColor)
        .onAppear {
            setUpDashboardVisibility()
            setupKeyboardObservers()
        }
    }

       
       private func setupKeyboardObservers() {
           NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
               isKeyboardVisible = true
           }

           NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
               isKeyboardVisible = false
           }
       }
       
       func setUpDashboardVisibility(){
           NotificationCenter.default.addObserver(forName: .dashboardVisibilityChanged, object: nil, queue: .main) { notification in
               if let isVisible = notification.userInfo?[Constants.isDashboardBottomNavigationVisible] as? Bool {
                   isDashboardBottomNavigationVisible = isVisible
               }
           }
       }
   }

extension DashboardView{
    func MyCustomTab(image: String, title: String, isSelected: Bool, bgColor: Color) -> some View{
        VStack(spacing: 4) {
            Image(systemName: image)
                .font(.system(size: 20, weight: .bold))
            Text(title)
                .font(.custom("Exo2-Medium", size: 14))
        }
        .foregroundColor(isSelected ? Color.theme.primaryColor : .gray)
    }
}

struct TabNavigationView<Content: View>: View {
    @ObservedObject var router: Router
    let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Route.self) { route in
                    viewForRoute(route, router: router)
                }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(TabRouter())
        .environmentObject(Router())
}
