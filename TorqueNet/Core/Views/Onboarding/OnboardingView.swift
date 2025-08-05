//
//  LandingView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct OnboardingView: View {
    let action: () -> Void
    @StateObject private var manager = OnboardingManager()
    @State private var showBtn = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack{
            Color.theme.surfaceColor.ignoresSafeArea()
            if !manager.items.isEmpty {
                TabView{
                    ForEach(manager.items) { item in
                        OnboardingInfoView(item: item)
                            .onAppear{
                                if item == manager.items.last {
                                    withAnimation(.spring().delay(0.35)) {
                                        showBtn = true
                                    }
                                }
                                else {
                                    showBtn = false
                                }
                            }
                            .overlay(alignment: .bottom) {
                                if showBtn {
                                    CustomButtonView(
                                        buttonName:"Continue",
                                        onTap: {
                                            action()
                                            router.push(.login)
                                        }
                                    )
                                    .padding()
                                    .offset(y: 60)
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
               
            }
        }
        .onAppear{
            manager.load()
        }
    }
}

#Preview {
    OnboardingView{
        
    }
}
