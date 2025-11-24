//
//  ThemeSelectionView.swift
//  TorqueNet
//
//  Created by MAC on 28/10/2025.
//
import SwiftUI

struct ThemeSelectionView: View {
    @EnvironmentObject var themesViewModel: ThemesViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                            settingsViewModel.updateShowThemeSelectorDialog(value: false)
                        }
                        
                        ThemeOptionView(
                            theme: .dark,
                            title: "Dark",
                            subtitle: "Easy on the eyes",
                            icon: "moon.fill",
                            isSelected: themesViewModel.currentTheme == .dark
                        ) {
                            themesViewModel.changeTheme(to: .dark)
                            settingsViewModel.updateShowThemeSelectorDialog(value: false)
                        }
                        
                        ThemeOptionView(
                            theme: .device,
                            title: "Follow System",
                            subtitle: "Adapts to your device settings",
                            icon: "gearshape.fill",
                            isSelected: themesViewModel.currentTheme == .device
                        ) {
                            themesViewModel.changeTheme(to: .device)
                            settingsViewModel.updateShowThemeSelectorDialog(value: false)
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
