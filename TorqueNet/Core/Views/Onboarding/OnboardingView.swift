//
//  LandingView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct OnboardingView: View {
    let action: () -> Void
    @StateObject private var manager = OnboardingManager()
    @State private var currentPage = 0
    @State private var showBtn = false
    @EnvironmentObject var router: Router

    private var totalPages: Int {
        manager.items.count
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if !manager.items.isEmpty {
                TabView(selection: $currentPage) {
                    ForEach(Array(manager.items.enumerated()), id: \.offset) { index, item in
                        OnboardingInfoView(
                            item: item,
                            currentPage: $currentPage
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
            }

            if totalPages > 1 {
                HStack(spacing: 12) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.theme.primaryColor : Color.theme.primaryColor.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 80)
                .transition(.opacity)
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
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color.theme.surfaceColor.opacity(0.8),
                    Color.theme.surfaceColor
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .onAppear {
            manager.load()
        }
        .onChange(of: currentPage) { newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showBtn = newValue == totalPages - 1
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.primaryColor)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.theme.primaryColor).withAlphaComponent(0.2)
        }
    }
}


#Preview {
    OnboardingView{
        
    }
}
