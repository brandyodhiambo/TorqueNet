//
//  ChangePasswordView.swift
//  TorqueNet
//
//  Created by MAC on 30/10/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var settingsViewModel : SettingsViewModel

    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack(alignment: .leading, spacing: 10){
                Text("Please enter your new password")
                    .font(.custom("Exo2-Regular", size: 16))
                    .foregroundColor(.theme.primaryColor)
                    .padding(.top, 10)
                
                PasswordInputFieldView(
                    description: "Current Password",
                    placeHolder: "********",
                    text: $settingsViewModel.currentPassword,
                    foregroundColor: Color.theme.onSurfaceColor,
                    errorMessage: settingsViewModel.settingErrors["currentPassword"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updateCurrentPassword(value: text)
                    }

                )
                
                PasswordInputFieldView(
                    description: "New Password",
                    placeHolder: "********",
                    text: $settingsViewModel.newPassword,
                    foregroundColor: Color.theme.onSurfaceColor,
                    errorMessage: settingsViewModel.settingErrors["newPassword"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updateNewPassword(value: text)
                    }

                )
                
                CustomButtonView(
                    buttonName:"Change Password",
                    isDisabled: !settingsViewModel.isChangePasswordEnable,
                    onTap: {
                        Task{
                            await settingsViewModel.changePassword(
                                onSuccess: {
                                    settingsViewModel.updateIsShowAlertDialog(value: true)
                                    settingsViewModel.updateDialogEntity(
                                        value: DialogEntity(
                                            title: "Request Password Change Successful!",
                                            message: "Please check your email for password reset link and proceed to login.",
                                            icon: "",
                                            confirmButtonText: "Proceed",
                                            dismissButtonText: "",
                                            onConfirm: {
                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                                router.push(.login)
                                            },
                                            onDismiss: {
                                                settingsViewModel.updateIsShowAlertDialog(value: false)
                                            }
                                        )
                                    )
                                    
                                }, onFailure:{error in
                                    settingsViewModel.toast = Toast(style: .error, message: error.localizedCaseInsensitiveContains("401") ? "Invalid current password" : "Failed to change password")
                                }
                            )
                        }
                    }
                )
                
                
            }
            .padding(20)
          
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Change Password",
            leadingIcon: "chevron.left",
            onLeadingTap: { router.pop() },
            trailingMenu: {}
        )
        .toastView(toast: $settingsViewModel.toast)
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
        .fullScreenProgressOverlay(isShowing: settingsViewModel.settingState == .isLoading )
    }
}

#Preview {
    NavigationView{
        ChangePasswordView()
    }
    
}
