//
//  CustomImageView.swift
//  TorqueNet
//
//  Created by MAC on 05/11/2025.
//


import SwiftUI
import Kingfisher

struct CustomImageView: View {
    let url: String
    var maxWidth: CGFloat = .infinity
    var height: CGFloat = 256
    
    var body: some View {
        KFImage(URL(string: url))
            .placeholder {
                ProgressView()
            }
            .onFailure { _ in
                print("Image failed to load: \(url)")
            }
            .resizable()
            .scaledToFill()
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .background(Color.theme.surfaceColor)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                KFOverlay(url: url)
            )
    }
}

struct KFOverlay: View {
    let url: String
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .scaledToFit()
            .opacity(0)
            .overlay(
                Image(systemName: "profile")
                    .foregroundColor(.gray)
                    .opacity(0.7)
            )
    }
}


#Preview {
    CustomImageView(url: "https://hws.dev/paul3.jpg")
}
