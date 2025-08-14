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
        ZStack(alignment: .bottom) {
            if !manager.items.isEmpty {
                TabView {
                    ForEach(manager.items) { item in
                        OnboardingInfoView(item: item)
                            .onAppear {
                                if item == manager.items.last {
                                    withAnimation(.spring().delay(0.3)) {
                                        showBtn = true
                                    }
                                } else {
                                    withAnimation {
                                        showBtn = false
                                    }
                                }
                            }
                    }
                }
                .tabViewStyle(.page)
                .ignoresSafeArea()
            }

            if showBtn {
                CustomButtonView(
                    buttonName: "Continue",
                    onTap: {
                        action()
                        router.push(.login)
                    }
                )
                .padding(.bottom, 32)
                .padding()
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(Color.theme.surfaceColor)
        .onAppear {
            manager.load()

            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.primaryColor)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.theme.primaryColor).withAlphaComponent(0.2)
        }

    }
}


#Preview {
    OnboardingView{
        
    }
}
