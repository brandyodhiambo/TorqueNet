//
//  LoginView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI
struct LoginView: View {
    var onLoginSuccess: () -> Void
    var onLoginFailure: (String) -> Void
    @EnvironmentObject var router: Router
    @StateObject var loginViewModel = LoginViewModel()
    
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
            
            // Card Section
            VStack(spacing: 20) {
                Text("Sign in Your Account")
                    .font(.custom("Exo2-Bold", size: 20))
                    .foregroundColor(.theme.primaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputFieldView(
                    description: "Email",
                    placeHolder: "johndoe@gmail.com",
                    text: $loginViewModel.uiState.email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    errorMessage: loginViewModel.uiState.loginErrors["email"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        loginViewModel.onAction(.onEmailChange(text))
                    }
                    
                )
                
                PasswordInputFieldView(
                    description: "Password",
                    placeHolder: "********",
                    text: $loginViewModel.uiState.password,
                    foregroundColor: Color.theme.onSurfaceColor,
                    errorMessage: loginViewModel.uiState.loginErrors["password"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        loginViewModel.onAction(.onPasswordChange(text))
                    }
                    
                )
                
                HStack {
                    Toggle(
                        isOn: Binding(
                            get: { loginViewModel.uiState.rememberMe },
                            set: { loginViewModel.onAction(.onRememberMe($0)) }
                        )
                    ) {
                        Text("Remember me")
                            .font(.custom("Exo2-Medium", size: 15))
                            .foregroundColor(Color.theme.primaryColor)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(Color.theme.onSurfaceColor)
                    
                    Spacer()
                    Button("Forgot Password?") {
                        router.push(.forgotPassword)
                    }
                    .foregroundColor(.theme.primaryColor)
                    .font(.custom("Exo2-Medium", size: 15))
                }
                
                CustomButtonView(
                    buttonName:"Sign In",
                    isDisabled: !loginViewModel.uiState.isLoginEnable,
                    onTap: {
                        loginViewModel.onAction(.login)
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
                    Text("Don’t have an account?")
                        .foregroundColor(Color.theme.onSurfaceColor)
                    Button("Sign Up") {
                        router.push(.register)
                    }
                    .foregroundColor(Color.theme.primaryColor)
                    .fontWeight(.semibold)
                }
                .font(.custom("Exo2-Regular", size: 14))
                .padding(.top, 8)
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
                isPresented: $loginViewModel.uiState.isShowAlertDialog,
                title: loginViewModel.uiState.dialogEntity.title,
                text: loginViewModel.uiState.dialogEntity.message,
                confirmButtonText: loginViewModel.uiState.dialogEntity.confirmButtonText,
                dismissButtonText: loginViewModel.uiState.dialogEntity.dismissButtonText,
                imageName: loginViewModel.uiState.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = loginViewModel.uiState.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = loginViewModel.uiState.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .background(Color.theme.surfaceColor)
        .ignoresSafeArea(edges: .all)
        .fullScreenProgressOverlay(isShowing: loginViewModel.uiState.loginState == .isLoading )
        .onReceive(loginViewModel.$effect) { effect in
            guard let effect = effect else { return }
            switch effect {
            case .navigateToDashboard:
                if loginViewModel.uiState.rememberMe {
                    onLoginSuccess()
                }
                router.push(.dashboard)
            case .showError(let message):
                loginViewModel.updateIsShowAlertDialog(value: true)
                loginViewModel.updateDialogEntity(
                    value: DialogEntity(
                        title: "Login Failed.",
                        message: message,
                        icon: "",
                        confirmButtonText: "",
                        dismissButtonText: "Okay",
                        onConfirm: {
                            loginViewModel.updateIsShowAlertDialog(value: false)
                        },
                        onDismiss: {
                            loginViewModel.updateIsShowAlertDialog(value: false)
                        }
                    )
                )
            }
            
            loginViewModel.effect = nil
        }
    }
}


#Preview {
    LoginView(
        onLoginSuccess: {},
        onLoginFailure: {_ in}
    )
}
