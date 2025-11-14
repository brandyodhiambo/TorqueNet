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
   
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 20){
                ProfileImageView(
                    localImage: settingsViewModel.profileImage,
                    remoteImageUrl: settingsViewModel.currentUser?.profileImageUrl,
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
                    isEditable: false,
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
                
                HStack{
                    Toggle(isOn: $settingsViewModel.isSeller) {
                        Text("Change Profile to Seller")
                            .font(.custom("Exo2-Medium", size: 15))
                            .foregroundColor(Color.theme.primaryColor)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(Color.theme.onSurfaceColor)
                    Spacer()
                }
                
               
                
                CustomButtonView(
                    buttonName:"Edit",
                    isDisabled: !settingsViewModel.isEditProfile,
                    onTap: {
                        Task{
                            await settingsViewModel.editUser(
                                onSuccess: {
                                    settingsViewModel.toast = Toast(style: .success, message: "You have successfully edited your profile.")
                                }, onFailure:{error in
                                    settingsViewModel.toast = Toast(style: .error, message: error)
                                }
                            )
                        }
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
        .toastView(toast: $settingsViewModel.toast)
        .onAppear {
            Task{
                await settingsViewModel.fetchUser(onSuccess: { user in
                    settingsViewModel.updateEmail(value: user.email)
                    settingsViewModel.updateLastName(value: Utils.shared.splitFullName(user.name).lastName)
                    settingsViewModel.updateFirstName(value: Utils.shared.splitFullName(user.name).firstName)
                    settingsViewModel.updatePhoneNumber(value: user.phoneNumber)
                    settingsViewModel.isSeller = user.isSeller
                }, onFailure: { error in
                    settingsViewModel.toast = Toast(style: .error, message: error)
                })
            }
        }
    }
}

#Preview {
    NavigationView{
        EditProfileView()
    }
}
