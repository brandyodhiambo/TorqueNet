//
//  EmptyStateView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 09/01/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let title: String
    let subtitle: String?
    var height: CGFloat = 160

    var body: some View {
        VStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .opacity(0.7)

            Text(title)
                .font(.custom("Exo2-Bold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)

            if let subtitle {
                Text(subtitle)
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .padding()
        .background(Color.theme.surfaceColor)
        .cornerRadius(16)
    }
}
