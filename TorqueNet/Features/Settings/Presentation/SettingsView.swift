//
//  SettingsScreen.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themesViewModel: ThemesViewModel
    @State private var showThemeSelector = false
    
    var body: some View {
        NavigationView {
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
                            subtitle: "Theme: \(themesViewModel.currentTheme.themName)",
                            action: {
                                showThemeSelector = true
                            }
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
            .sheet(isPresented: $showThemeSelector) {
                ThemeSelectionView()
                   
            }
        }
    }
}

struct ThemeSelectionView: View {
    @EnvironmentObject var themesViewModel: ThemesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    Text("Choose your preferred theme")
                        .font(.custom("Exo2-Regular", size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        ThemeOptionView(
                            theme: .light,
                            title: "Light",
                            subtitle: "Classic bright appearance",
                            icon: "sun.max.fill",
                            isSelected: themesViewModel.currentTheme == .light
                        ) {
                            themesViewModel.changeTheme(to: .light)
                        }
                        
                        ThemeOptionView(
                            theme: .dark,
                            title: "Dark",
                            subtitle: "Easy on the eyes",
                            icon: "moon.fill",
                            isSelected: themesViewModel.currentTheme == .dark
                        ) {
                            themesViewModel.changeTheme(to: .dark)
                        }
                        
                        ThemeOptionView(
                            theme: .device,
                            title: "Follow System",
                            subtitle: "Adapts to your device settings",
                            icon: "gearshape.fill",
                            isSelected: themesViewModel.currentTheme == .device
                        ) {
                            themesViewModel.changeTheme(to: .device)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .background(Color.theme.surfaceColor)
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .font(.custom("Exo2-Medium", size: 16))
            )
        }
    }
}

struct ThemeOptionView: View {
    let theme: ThemeModel
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
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
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.theme.primaryColor)
                        .font(.system(size: 20))
                } else {
                    Circle()
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? Color.theme.primaryColor : Color.secondary.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
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
    
    private var iconColor: Color {
        switch theme {
        case .light:
            return .orange
        case .dark:
            return .indigo
        case .device:
            return .purple
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
                        color: Color.theme.onSurfaceColor.opacity(0.05),
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
