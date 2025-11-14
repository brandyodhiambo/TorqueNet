//
//  SettingsScreen.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themesViewModel: ThemesViewModel
    @EnvironmentObject var router:Router
    @ObservedObject var settingsViewModel =  SettingsViewModel()
    @ObservedObject var forgotPasswordViewModel = ForgotPasswordViewModel()
    
    var body: some View {
        NavigationView {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    SettingsRowView(
                        icon: "person.circle.fill",
                        iconColor: .blue,
                        title: "Account",
                        subtitle: settingsViewModel.currentUser?.email ?? "Loading...",
                        action: {
                            router.push(.profile)
                        }
                    )
                    
                    SettingsRowView(
                        icon: "paintbrush.pointed.fill",
                        iconColor: .purple,
                        title: "Personalisation",
                        subtitle: "Theme: \(themesViewModel.currentTheme.themName)",
                        action: {
                            settingsViewModel.updateShowThemeSelectorDialog(value: true)
                        }
                    )
                    
                    SettingsRowView(
                        icon: "lock.circle.fill",
                        iconColor: .green,
                        title: "Password",
                        subtitle: "Update your password",
                        action: {
                            router.push(.changePassword)
                        }
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
                        action: {
                            settingsViewModel.updateIsShowAlertDialog(value: true)
                            settingsViewModel.updateDialogEntity(
                                value: DialogEntity(
                                    title: "Sign Out",
                                    message: "Do you really want to sign out?",
                                    icon: "",
                                    confirmButtonText: "Okay",
                                    dismissButtonText: "Cancel",
                                    onConfirm: {
                                        Task{
                                            await settingsViewModel.logoutUser(
                                                onSuccess: { logout in
                                                    settingsViewModel.updateIsShowAlertDialog(value: !logout)
                                                    router.popToRoot()
                                                },
                                                onFailure: { error in
                                                    settingsViewModel.updateIsShowAlertDialog(value: true)
                                                    settingsViewModel.updateDialogEntity(
                                                        value: DialogEntity(
                                                            title: "Unable to sign out this account. Please try again later.",
                                                            message: error,
                                                            icon: "",
                                                            confirmButtonText: "",
                                                            dismissButtonText: "Okay",
                                                            onConfirm: {
                                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                                            },
                                                            onDismiss: {
                                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                                            }
                                                        )
                                                    )
                                                }
                                            )
                                        }
                                    },
                                    onDismiss: {
                                        settingsViewModel.updateIsShowAlertDialog(value: false)
                                    }
                                )
                            )
                        }
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
                        action: {
                            settingsViewModel.updateIsShowAlertDialog(value: true)
                            settingsViewModel.updateDialogEntity(
                                value: DialogEntity(
                                    title: "Delete Account",
                                    message: "Once you delete the account you will lose all your data. This action cannot be undone. Are you sure you want to proceed?",
                                    icon: "",
                                    confirmButtonText: "Okay",
                                    dismissButtonText: "Cancel",
                                    onConfirm: {
                                        Task{
                                            await settingsViewModel.deleteAccount(
                                                onSuccess: { deleted in
                                                    settingsViewModel.updateIsShowAlertDialog(value: !deleted)
                                                },
                                                onFailure: { error in
                                                    settingsViewModel.updateIsShowAlertDialog(value: true)
                                                    settingsViewModel.updateDialogEntity(
                                                        value: DialogEntity(
                                                            title: "Unable to delete account. Please try again later.",
                                                            message: error,
                                                            icon: "",
                                                            confirmButtonText: "",
                                                            dismissButtonText: "Okay",
                                                            onConfirm: {
                                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                                            },
                                                            onDismiss: {
                                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                                            }
                                                        )
                                                    )
                                                }
                                            )
                                        }
                                    },
                                    onDismiss: {
                                        settingsViewModel.updateIsShowAlertDialog(value: false)
                                    }
                                )
                            )
                        }
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
            onTrailingTap: nil,
            trailingMenu: {}
        )
        .overlay {
            CustomAlertDialogView(
                isPresented: $settingsViewModel.isShowAlertDialog,
                title: settingsViewModel.dialogEntity.title,
                text: settingsViewModel.dialogEntity.message,
                confirmButtonText: settingsViewModel.dialogEntity.confirmButtonText,
                dismissButtonText: settingsViewModel.dialogEntity.dismissButtonText,
                imageName: settingsViewModel.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = settingsViewModel.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = settingsViewModel.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .onAppear {
            Task{
                await settingsViewModel.fetchUser(onSuccess: { user in
                }, onFailure: { error in
                    settingsViewModel.updateIsShowAlertDialog(value: true)
                    settingsViewModel.updateDialogEntity(
                        value: DialogEntity(
                            title: "Unable to fetch user. Please try again later.",
                            message: error,
                            icon: "",
                            confirmButtonText: "",
                            dismissButtonText: "Okay",
                            onConfirm: {
                                settingsViewModel.updateIsShowAlertDialog(value: false)
                            },
                            onDismiss: {
                                settingsViewModel.updateIsShowAlertDialog(value: false)
                            }
                        )
                    )
                })
            }
        }
        .sheet(isPresented: $settingsViewModel.showThemeSelector) {
            ThemeSelectionView()
            
        }
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
