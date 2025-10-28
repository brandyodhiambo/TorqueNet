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
    
    @State private var showImagePicker = false
    @State private var profileImage: UIImage? = nil
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.surfaceColor
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header with Navigation
                        headerView
                        
                        // Decorative Background
                        ZStack(alignment: .top) {
                            
                            VStack(spacing: 0) {
                                // Camera Button
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
                                            showImagePicker = true
                                        }
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 60)
                            }
                            .frame(height: 140)
                        }
                        .frame(height: 140)
                        
                        // Profile Card
                        profileCardView
                        
                        // Stats Section
                        statsSection
                        
                        // Action Buttons
                        actionsSection
                        
                        Spacer()
                            .frame(height: 20)
                    }
                }
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
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $profileImage)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: {
                router.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryColor)
                            .shadow(color: Color.theme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Profile")
                    .font(.custom("Exo2-Bold", size: 28))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Text("Manage your account")
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private var profileCardView: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .theme.primaryColor,
                                            .theme.primaryColor.opacity(0.6)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: Color.theme.primaryColor.opacity(0.3), radius: 10, x: 0, y: 4)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .foregroundColor(.gray.opacity(0.3))
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .theme.primaryColor.opacity(0.5),
                                            .theme.primaryColor.opacity(0.2)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                }
                
                // Status Badge
                Circle()
                    .fill(Color.green)
                    .frame(width: 16, height: 16)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            .padding(.top, -120)
            
            // User Info
            VStack(spacing: 6) {
                Text(currentUser?.name ?? "Loading...")
                    .font(.custom("Exo2-Bold", size: 22))
                    .foregroundColor(.theme.onSurfaceColor)
            }
            
            // Divider with gradient
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
            
            // Profile Details Grid
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
                    label: "User ID",
                    value: "22200",
                    icon: "person.badge.key.fill"
                )
                
                ProfileDetailItem(
                    label: "Member Since",
                    value: currentUser?.createdAt?.description ?? "Loading...",
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
                StatCard(title: "Total Cars", value: "3", icon: "car.fill")
                StatCard(title: "Rides", value: "42", icon: "road.lanes")
                StatCard(title: "Rating", value: "4.8", icon: "star.fill")
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
                    action: {}
                )
                
                ProfileActionButton(
                    icon: "lock.circle.fill",
                    title: "Change Password",
                    subtitle: "Secure your account",
                    iconColor: .green,
                    action: {}
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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ProfileView()
}
