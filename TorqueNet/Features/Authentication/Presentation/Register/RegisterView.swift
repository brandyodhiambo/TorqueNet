//
//  RegisterView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @StateObject var registerViewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Spacer().frame(height: 50)
                Text("TorqueNet")
                    .font(.custom("Exo2-ExtraBold", size: 40))
                    .foregroundColor(Color.theme.primaryColor)
                
                Image("appCar")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .rotationEffect(.degrees(25))
                    .offset(x:16,y:50)
            }
            .padding(.horizontal,12)
            Spacer()
            
            VStack(spacing: 20) {
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(){
                        Text("Create Account")
                            .font(.custom("Exo2-Bold", size: 20))
                            .foregroundColor(.theme.primaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        InputFieldView(
                            description: "First Name",
                            placeHolder: "John",
                            text: $registerViewModel.uiState.firstName,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .default,
                            errorMessage: registerViewModel.uiState.registerErrors["firstName"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onFirstNameChange(text))
                            }
                        )
                        
                        InputFieldView(
                            description: "Last Name",
                            placeHolder: "Doe",
                            text: $registerViewModel.uiState.lastName,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .default,
                            errorMessage: registerViewModel.uiState.registerErrors["lastName"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onLastNameChange(text))
                            }
                        )
                        
                        InputFieldView(
                            description: "Email",
                            placeHolder: "johndoe@gmail.com",
                            text: $registerViewModel.uiState.email,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .emailAddress,
                            errorMessage: registerViewModel.uiState.registerErrors["email"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onEmailChange(text))
                            }
                        )
                        
                        InputFieldView(
                            description: "Phone Number",
                            placeHolder: "07---------",
                            text: $registerViewModel.uiState.phoneNumber,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .numberPad,
                            errorMessage: registerViewModel.uiState.registerErrors["phoneNumber"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onPhoneNumberChange(text))
                            }
                        )
                        
                        PasswordInputFieldView(
                            description: "Password",
                            placeHolder: "********",
                            text: $registerViewModel.uiState.password,
                            foregroundColor: Color.theme.onSurfaceColor,
                            errorMessage: registerViewModel.uiState.registerErrors["password"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onPasswordChange(text))
                            }
                        )
                        
                        PasswordInputFieldView(
                            description: "Confirm Password",
                            placeHolder: "********",
                            text: $registerViewModel.uiState.confirmPassword,
                            foregroundColor: Color.theme.onSurfaceColor,
                            errorMessage: registerViewModel.uiState.registerErrors["confirmPassword"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: { text in
                                registerViewModel.onAction(_intent: .onConfirmPasswordChange(text))
                            }
                        )
                        
                        CustomButtonView(
                            buttonName:"Sign Up",
                            isDisabled: !registerViewModel.uiState.isRegisterEnabled,
                            onTap: {
                                registerViewModel.onAction(_intent: .register)
                            }
                        )
                        
                        VStack(spacing: 12) {
                            Text("Or sign in with")
                                .font(.custom("Exo2-Medium", size: 15))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 16) {
                                ForEach(["google", "facebook" ], id: \.self) { iconName in
                                    Button(action: {}) {
                                        Image(iconName)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .shadow(radius: 1)
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(Color.theme.onSurfaceColor)
                            Button("Sign In") {
                                router.push(.login)
                            }
                            .foregroundColor(Color.theme.primaryColor)
                            .fontWeight(.semibold)
                        }
                        .font(.custom("Exo2-Regular", size: 14))
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color.theme.onSurfaceColor.opacity(0.1))
                    .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                    .frame(maxWidth: .infinity, maxHeight: 900)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .overlay {
            CustomAlertDialogView(
                isPresented: $registerViewModel.uiState.isShowAlertDialog,
                title: registerViewModel.uiState.dialogEntity.title,
                text: registerViewModel.uiState.dialogEntity.message,
                confirmButtonText: registerViewModel.uiState.dialogEntity.confirmButtonText,
                dismissButtonText: registerViewModel.uiState.dialogEntity.dismissButtonText,
                imageName: registerViewModel.uiState.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = registerViewModel.uiState.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = registerViewModel.uiState.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .background(Color.theme.surfaceColor)
        .ignoresSafeArea(edges: .all)
        .fullScreenProgressOverlay(isShowing: registerViewModel.uiState.registeState == .isLoading )
        .onReceive(registerViewModel.$effect) { effect in
            guard let effect = effect else { return }
            switch effect {
                case .successDialog:
                registerViewModel.updateIsShowAlertDialog(value: true)
                registerViewModel.updateDialogEntity(
                    value: DialogEntity(
                        title: "Registration Successful!",
                        message: "Welcome to the community!\nPlease check your email for verification link and proceed to login.",
                        icon: "",
                        confirmButtonText: "Proceed",
                        dismissButtonText: "",
                        onConfirm: {
                            registerViewModel.updateIsShowAlertDialog(value: false)
                            dismiss()
                        },
                        onDismiss: {
                            registerViewModel.updateIsShowAlertDialog(value: false)
                        }
                    )
                )
                case .showError(let message):
                registerViewModel.updateIsShowAlertDialog(value: true)
                registerViewModel.updateDialogEntity(
                    value: DialogEntity(
                        title: "Registration Failed.",
                        message: message,
                        icon: "",
                        confirmButtonText: "",
                        dismissButtonText: "Okay",
                        onConfirm: {
                            registerViewModel.updateIsShowAlertDialog(value: false)
                        },
                        onDismiss: {
                            registerViewModel.updateIsShowAlertDialog(value: false)
                        }
                    )
                )
                registerViewModel.effect = nil
                
            }
        }
        
    }
}

#Preview {
    RegisterView()
}
