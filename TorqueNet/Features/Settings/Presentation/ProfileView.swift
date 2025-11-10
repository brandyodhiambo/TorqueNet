//
//  ProfileView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var settingsViewModel =  SettingsViewModel()
    
    @State var currentUser: User?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color.theme.primaryColor)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(16)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    settingsViewModel.updateShowImagePickerDialog(value: true)
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 60)
                    }
                    .frame(height: 140)
                }
                .frame(height: 140)
                
                profileCardView
                
                statsSection
                
                actionsSection
                
                Spacer()
                    .frame(height: 20)
            }
            
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Profile",
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
        .sheet(isPresented: $settingsViewModel.showImagePicker) {
            ImagePicker(
                image: $settingsViewModel.profileImage,
                onSave: { image in
                    if let image = image {
                        settingsViewModel.updateProfileImage(value: image)
                        Task {
                            await settingsViewModel.uploadAndSaveProfileImage()
                        }
                    }
                }
            )
        }
    }
    
    
    private var profileCardView: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                
                ProfileImageView(
                    localImage: settingsViewModel.profileImage,
                    remoteImageUrl: currentUser?.profileImageUrl
                )
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 16, height: 16)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            .padding(.top, -120)
            
            VStack(spacing: 6) {
                Text(currentUser?.name ?? "Loading...")
                    .font(.custom("Exo2-Bold", size: 22))
                    .foregroundColor(.theme.onSurfaceColor)
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .theme.primaryColor.opacity(0.3),
                    .clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
            
            VStack(spacing: 12) {
                ProfileDetailItem(
                    label: "Email",
                    value: currentUser?.email ?? "Loading...",
                    icon: "envelope.fill"
                )
                
                ProfileDetailItem(
                    label: "Phone",
                    value: currentUser?.phoneNumber ?? "Loading...",
                    icon: "phone.fill"
                )
                
                
                ProfileDetailItem(
                    label: "Member Since",
                    value: Utils.shared.formatReadableDate(currentUser?.createdAt ?? Date()),
                    icon: "calendar.circle.fill"
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.surfaceColor)
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            Text("Account Stats")
                .font(.custom("Exo2-Bold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                StatCard(title: "Total Cars", value: currentUser?.cars.description ?? "0", icon: "car.fill")
                StatCard(title: "Rides", value: currentUser?.rides.description ?? "0", icon: "road.lanes")
                StatCard(title: "Seller", value: currentUser?.isSeller == true ? "Yes" : "No", icon: "star.fill")
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 4)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Text("Actions")
                .font(.custom("Exo2-Bold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            VStack(spacing: 10) {
                ProfileActionButton(
                    icon: "pencil.circle.fill",
                    title: "Edit Profile",
                    subtitle: "Update your information",
                    iconColor: .blue,
                    action: {
                        router.push(.editProfile)
                    }
                )
                
                ProfileActionButton(
                    icon: "lock.circle.fill",
                    title: "Change Password",
                    subtitle: "Secure your account",
                    iconColor: .green,
                    action: {
                        router.push(.changePassword)
                    }
                )
                
                ProfileActionButton(
                    icon: "bell.circle.fill",
                    title: "Notifications",
                    subtitle: "Manage notification settings",
                    iconColor: .orange,
                    action: {}
                )
                
                ProfileActionButton(
                    icon: "rectangle.portrait.and.arrow.right.fill",
                    title: "Logout",
                    subtitle: "Sign out from your account",
                    iconColor: .red,
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
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 4)
        .padding(.top, 12)
    }
}

struct ProfileDetailItem: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.theme.primaryColor)
                .frame(width: 32, height: 32)
                .background(Color.theme.primaryColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.custom("Exo2-Medium", size: 11))
                    .foregroundColor(.secondary.opacity(0.7))
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.custom("Exo2-Regular", size: 13))
                    .foregroundColor(.theme.onSurfaceColor)
            }
            
            Spacer()
        }
    }
}


struct ProfileImageView: View {
    var localImage: UIImage?
    var remoteImageUrl: String?
    var size: CGFloat = 110

    private var gradientStroke: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                .theme.primaryColor.opacity(0.8),
                .theme.primaryColor.opacity(0.4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            if let image = localImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if let url = remoteImageUrl, !url.isEmpty {
                CustomImageView(url: url, maxWidth: size, height: size)
                    .scaledToFill()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(gradientStroke, lineWidth: 3)
        )
        .shadow(color: Color.theme.primaryColor.opacity(0.3), radius: 10, x: 0, y: 4)
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.theme.primaryColor)
            
            Text(value)
                .font(.custom("Exo2-Bold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            
            Text(title)
                .font(.custom("Exo2-Regular", size: 11))
                .foregroundColor(.secondary.opacity(0.7))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.surfaceColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.onSurfaceColor.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(iconColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Exo2-SemiBold", size: 14))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text(subtitle)
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.4))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.theme.surfaceColor)
                    .shadow(color: Color.black.opacity(isPressed ? 0.1 : 0.03), radius: 8, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.97 : 1)
        }
        .onLongPressGesture(minimumDuration: 0, perform: {}, onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressing
            }
        })
    }
}



#Preview {
    NavigationView{
        ProfileView()
    }
    
}
