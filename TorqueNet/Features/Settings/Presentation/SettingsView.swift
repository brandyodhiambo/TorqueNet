//
//  SettingsScreen.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI
//
//struct SettingsView: View {
//    var body: some View {
//        Text("Settings Screen")
//    }
//}
//
//#Preview {
//    SettingsView()
//}

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    SettingsRowView(
                        icon: "person.circle.fill",
                        iconColor: .blue,
                        title: "Account",
                        subtitle: "brandyodhiambo@gmail.com",
                        action: {}
                    )
                    
                    SettingsRowView(
                        icon: "paintbrush.pointed.fill",
                        iconColor: .purple,
                        title: "Personalisation",
                        subtitle: "Set your theme and logo",
                        action: {}
                    )
                    
                    SettingsRowView(
                        icon: "lock.circle.fill",
                        iconColor: .green,
                        title: "Password",
                        subtitle: "Update your password",
                        action: {}
                    )
                    
                    SettingsRowView(
                        icon: "star.circle.fill",
                        iconColor: .orange,
                        title: "Rate the app",
                        subtitle: "Let us know how you feel",
                        action: {}
                    )
                    
                    SettingsRowView(
                        icon: "rectangle.portrait.and.arrow.right.fill",
                        iconColor: .pink,
                        title: "Sign out",
                        subtitle: "End your session",
                        action: {}
                    )
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text("Danger zone")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    SettingsRowView(
                        icon: "trash.circle.fill",
                        iconColor: .red,
                        title: "Delete account",
                        subtitle: "Erase your account details",
                        action: {}
                    )
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    Image(systemName: "lightbulb.max")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.5))
                    
                    Text("Learn more about us")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)
                
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Settings",
            leadingIcon: nil,
            navbarTitleDisplayMode: .automatic,
            onLeadingTap: nil,
            trailingIcon: nil,
            onTrailingTap: nil
        )
    }
    }
}

struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.surfaceColor)
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Light Mode") {
    NavigationView {
        SettingsView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationView {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}
