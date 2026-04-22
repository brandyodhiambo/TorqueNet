//
//  ForgotPasswordView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 07/08/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var router: Router
    @StateObject var forgotPasswordViewModel = ForgotPasswordViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Spacer().frame(height: 50)
                Text("TorqueNet")
                    .font(.theme.brand(size: 40))
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
                Text("Forgot Password?")
                    .font(.theme.title(size: 20))
                    .foregroundColor(.theme.primaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Enter your email below and we will send you a reset link.")
                    .font(.theme.body(size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputFieldView(
                    description: "Email",
                    placeHolder: "johndoe@gmail.com",
                    text: $forgotPasswordViewModel.uiState.email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    errorMessage: forgotPasswordViewModel.uiState.forgotPasswordErrors["email"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        forgotPasswordViewModel.onAction(_intent: .onEmailChanged(text))
                    }
                )
                
                
                CustomButtonView(
                    buttonName:"Send",
                    isDisabled: !forgotPasswordViewModel.uiState.isForgotPasswordEnable,
                    onTap: {
                        forgotPasswordViewModel.onAction(_intent: .forgotPassword)
                    }
                )
                
                HStack {
                    Text("Just Remembered your password?")
                        .foregroundColor(Color.theme.onSurfaceColor)
                    Button("Sign In") {
                        router.push(.login)
                    }
                    .foregroundColor(Color.theme.primaryColor)
                    .fontWeight(.semibold)
                }
                .font(.theme.caption(size: 14))
                .padding(.top, 8)
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color.theme.onSurfaceColor.opacity(0.1))
                    .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                    .frame(maxWidth: .infinity, maxHeight: 900)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .background(Color.theme.surfaceColor)
        .overlay {
            CustomAlertDialogView(
                isPresented: $forgotPasswordViewModel.uiState.isShowAlertDialog,
                title: forgotPasswordViewModel.uiState.dialogEntity.title,
                text: forgotPasswordViewModel.uiState.dialogEntity.message,
                confirmButtonText: forgotPasswordViewModel.uiState.dialogEntity.confirmButtonText,
                dismissButtonText: forgotPasswordViewModel.uiState.dialogEntity.dismissButtonText,
                imageName: forgotPasswordViewModel.uiState.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = forgotPasswordViewModel.uiState.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = forgotPasswordViewModel.uiState.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .fullScreenProgressOverlay(isShowing: forgotPasswordViewModel.uiState.forgotPasswordState == .isLoading )
        .ignoresSafeArea(edges: .all)
        .onReceive(forgotPasswordViewModel.$effect) { effect in
            guard let effect = effect else { return }
            switch effect {
                case .successDialog:
                forgotPasswordViewModel.updateIsShowAlertDialog(value: true)
                forgotPasswordViewModel.updateDialogEntity(
                    value: DialogEntity(
                        title: "Request Password Change Successful!",
                        message: "Please check your email for password reset link and proceed to login.",
                        icon: "",
                        confirmButtonText: "Proceed",
                        dismissButtonText: "",
                        onConfirm: {
                            forgotPasswordViewModel.updateIsShowAlertDialog(value: false)
                            router.push(.login)
                        },
                        onDismiss: {
                            forgotPasswordViewModel.updateIsShowAlertDialog(value: false)
                        }
                    )
                )
                case .showError(let message):
                forgotPasswordViewModel.updateIsShowAlertDialog(value: true)
                forgotPasswordViewModel.updateDialogEntity(
                    value: DialogEntity(
                        title: "Forgot Password Request Failed.",
                        message: message,
                        icon: "",
                        confirmButtonText: "",
                        dismissButtonText: "Okay",
                        onConfirm: {
                            forgotPasswordViewModel.updateIsShowAlertDialog(value: false)
                        },
                        onDismiss: {
                            forgotPasswordViewModel.updateIsShowAlertDialog(value: false)
                        }
                    )
                )
                forgotPasswordViewModel.effect = nil
                
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
