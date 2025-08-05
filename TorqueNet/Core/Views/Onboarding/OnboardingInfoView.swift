//
//  OnboardingInfoView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct OnboardingInfoView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack{
            Text(item.image)
                .font(.system(size: 150))
            
            Text(item.title)
                .font(.custom("Exo2-ExtraBold", size: 35))
                .foregroundColor(Color.theme.onSurfaceColor)
                .padding(.bottom, 12)
            
            Text(item.content)
                .font(.custom("Exo2-Light", size: 15))
                .foregroundColor(Color.theme.onSurfaceColor)
            
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    OnboardingInfoView(item: .init(image: "🤝", title: "Join the crew", content: "Handshake. Two hands performing a handshake gesture, indicating a cordial greeting between friends or associates."))
        .previewLayout(.sizeThatFits)
        .background(Color.theme.surfaceColor)
}
