//
//  OnboardingInfoView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct OnboardingInfoView: View {
    let item: OnboardingItem
    @Binding var currentPage: Int
    
    init(item: OnboardingItem, currentPage: Binding<Int>) {
        self.item = item
        self._currentPage = currentPage
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.55)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 100)
                    .ignoresSafeArea(edges: .top)
                }
                
                VStack(spacing: 24) {
                    Text(item.title)
                        .font(.custom("Exo2-ExtraBold", size: 32))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.theme.primaryColor, Color.theme.onSurfaceColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .multilineTextAlignment(.center)
                        .scaleEffect(CGFloat(1.0 + sin(Double(currentPage) * 0.1) * 0.02))
                        .opacity(CGFloat(0.9 + sin(Double(currentPage) * 0.1) * 0.1))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: currentPage)
                        .padding(.top, 16)
                    
                    Text(item.content)
                        .font(.custom("Exo2-Light", size: 16))
                        .foregroundColor(Color.theme.onSurfaceColor.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                .padding(.bottom, 48)
                
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .all)
    }
}


#Preview {
    OnboardingInfoView(item: .init(image: "carKey2", title: "Join the crew", content: "Handshake. Two hands performing a handshake gesture, indicating a cordial greeting between friends or associates."),currentPage:.constant(0))
        .previewLayout(.sizeThatFits)
        .background(Color.theme.surfaceColor)
}
