//
//  OnboardingInfoView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct OnboardingInfoView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 0){
            
            Image(item.image)
                .resizable()
                .scaledToFill()
                .frame(height: 500)
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text(item.title)
                        .font(.custom("Exo2-ExtraBold", size: 35))
                        .foregroundColor(Color.theme.onSurfaceColor)
                        .padding(.top, 24)

                    Text(item.content)
                        .font(.custom("Exo2-Light", size: 15))
                        .foregroundColor(Color.theme.onSurfaceColor)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 40)
            }
            
            Spacer()
        }
        .ignoresSafeArea(edges: .all)
    }
}


#Preview {
    OnboardingInfoView(item: .init(image: "carKey2", title: "Join the crew", content: "Handshake. Two hands performing a handshake gesture, indicating a cordial greeting between friends or associates."))
        .previewLayout(.sizeThatFits)
        .background(Color.theme.surfaceColor)
}
