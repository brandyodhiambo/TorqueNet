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

       var body: some View {
           ZStack(alignment: .bottom){
               TabView(selection: $tabRouter.selectedTab) {
                   HomeView()
                       .tag(TabItem.home)
                   
                   AuctionView()
                       .tag(TabItem.auction)
                   
                   WishListView()
                       .tag(TabItem.wishlist)
                   
                   SettingsView()
                       .tag(TabItem.settings)
               }

               if isDashboardBottomNavigationVisible && !isKeyboardVisible {
                   ZStack {
                       HStack(spacing: 0) {
                           ForEach(TabItem.allCases, id: \.self) { item in
                               Button {
                                   tabRouter.selectedTab = item
                               } label: {
                                   MyCustomTab(image: item.icon, title: item.title, isSelected: (tabRouter.selectedTab == item), bgColor: item.color)
                                       .frame(maxWidth: .infinity)
                               }
                           }
                       }
                       .frame(maxWidth: .infinity)
                       .padding(5)
                   }
                   .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
                   .background(.ultraThinMaterial)
                   .cornerRadius(12)
                   .overlay(
                       RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.theme.onSurfaceColor, lineWidth: 0.5)
                   )
                   .padding(.horizontal, 15)
                   .padding(.bottom, 30)
                  
               }
           }
           .ignoresSafeArea(.all, edges: .bottom)
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

#Preview {
    DashboardView()
        .environmentObject(TabRouter())
}
