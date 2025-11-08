//
//  EditProfile.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/11/2025.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @State var currentUser: User? = nil
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 20){
                ProfileImageView(
                    localImage: settingsViewModel.profileImage,
                    remoteImageUrl: currentUser?.profileImageUrl,
                    size: 150
                )
                
                InputFieldView(
                    description: "First Name",
                    placeHolder: "John",
                    text: $settingsViewModel.firstName,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .default,
                    errorMessage: settingsViewModel.settingErrors["firstName"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updateFirstName(value: text)
                    }
                )
                
                InputFieldView(
                    description: "Last Name",
                    placeHolder: "Doe",
                    text: $settingsViewModel.lastName,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .default,
                    errorMessage: settingsViewModel.settingErrors["lastName"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updateLastName(value: text)
                    }
                )
                
                InputFieldView(
                    description: "Email",
                    placeHolder: "John@gmail.com",
                    text: $settingsViewModel.email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    errorMessage: settingsViewModel.settingErrors["email"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updateEmail(value: text)
                    }
                )
                
                InputFieldView(
                    description: "Phone Number",
                    placeHolder: "07....",
                    text: $settingsViewModel.phoneNumber,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .default,
                    errorMessage: settingsViewModel.settingErrors["phoneNumber"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        settingsViewModel.updatePhoneNumber(value: text)
                    }
                )
                
                CustomButtonView(
                    buttonName:"Edit",
                    isDisabled: !settingsViewModel.isEditProfile,
                    onTap: {
                        /*Task{
                            await settingsViewModel.editProfile(
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
                                    settingsViewModel.updateIsShowAlertDialog(value: true)
                                    settingsViewModel.updateDialogEntity(
                                        value: DialogEntity(
                                            title: "Change Password Request Failed.",
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
                        }*/
                    }
                )
                
            }
            .padding(16)
            
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Edit Profile",
            leadingIcon: "chevron.left",
            onLeadingTap: { router.pop() },
            trailingMenu: {}
        )
        .onAppear {
            Task{
                await settingsViewModel.fetchUser(onSuccess: { user in
                    currentUser = user
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

    }
}

#Preview {
    NavigationView{
        EditProfileView()
    }
}
