//
//  ProfileView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct ProfileView: View {
    var onLogoutSuccess: () -> Void
    var onLogoutFailed: (String) -> Void
    @EnvironmentObject var router: Router
    @State private var showImagePicker = false
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    
                    ZStack(alignment: .top) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .theme.primaryColor.opacity(0.5),
                                .theme.primaryColor.opacity(0.7),
                                .theme.primaryColor.opacity(0.9),
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 180)
                        
                        VStack(spacing: 16) {
                            HStack {
                                Spacer()
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .onTapGesture {
                                        showImagePicker = true
                                    }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                            
                            Spacer()
                        }
                    }
                    
                    // Profile Image
                    VStack(spacing: 16) {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .padding(.top, -70)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding(.top, -70)
                        }
                        
                        // User Info
                        VStack(spacing: 4) {
                            Text("AVLIN THOMAS")
                                .font(.custom("Exo2-Bold", size: 18))
                                .foregroundColor(.theme.primaryColor)
                            
                            Text("NEWYORK")
                                .font(.custom("Exo2-Regular", size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.theme.surfaceColor)
                    
                    // Profile Details
                    VStack(spacing: 0) {
                        ProfileDetailRow(
                            label: "Name",
                            value: "Avlin Thomas",
                            labelColor: .theme.primaryColor
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        ProfileDetailRow(
                            label: "Email",
                            value: "Avlin_tms@gmail.com",
                            labelColor:  .theme.primaryColor
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        ProfileDetailRow(
                            label: "Phone",
                            value: "+1 (555) 123-4567",
                            labelColor:  .theme.primaryColor
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        ProfileDetailRow(
                            label: "Location",
                            value: "New York, USA",
                            labelColor:  .theme.primaryColor
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        ProfileDetailRow(
                            label: "User ID",
                            value: "22200",
                            labelColor:  .theme.primaryColor
                        )
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        ProfileDetailRow(
                            label: "Member Since",
                            value: "January 2024",
                            labelColor:  .theme.primaryColor
                        )
                    }
                    .background(Color.theme.surfaceColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    
                }
            }
            .background(Color.theme.surfaceColor)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profileImage)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                router.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.theme.primaryColor)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Profile")
                    .font(.custom("Exo2-Bold", size: 28))
                    .foregroundColor(.theme.onSurfaceColor)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
}

struct ProfileDetailRow: View {
    let label: String
    let value: String
    let labelColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Exo2-Medium", size: 12))
                .foregroundColor(labelColor)
            
            Text(value)
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 14)
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                    .frame(width: 30)
                
                Text(title)
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.theme.surfaceColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
            )
        }
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
    ProfileView(
        onLogoutSuccess: {
            
        },
        onLogoutFailed: {error in
            
        }
    )
}
