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
    @ObservedObject var loginViewModel = LoginViewModel()
    

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
                    text: $loginViewModel.email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    errorMessage: loginViewModel.loginErrors["email"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        loginViewModel.updateEmail(value: text)
                    }

                )
                
                PasswordInputFieldView(
                    description: "Password",
                    placeHolder: "********",
                    text: $loginViewModel.password,
                    foregroundColor: Color.theme.onSurfaceColor,
                    errorMessage: loginViewModel.loginErrors["password"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        loginViewModel.updatePassword(value: text)
                    }

                )

                HStack {
                    Toggle(isOn: $loginViewModel.rememberMe) {
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
                    isDisabled: !loginViewModel.isLoginEnable,
                    onTap: {
                        Task{
                            await loginViewModel.loginUser(onSuccess: {
                                if loginViewModel.rememberMe {
                                    onLoginSuccess()
                                }
                                router.push(.dashboard)
                            }, onFailure: {error in
                                loginViewModel.updateIsShowAlertDialog(value: true)
                                loginViewModel.updateDialogEntity(
                                    value: DialogEntity(
                                        title: "Login Failed.",
                                        message: error,
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
                            })
                        }
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
                isPresented: $loginViewModel.isShowAlertDialog,
                title: loginViewModel.dialogEntity.title,
                text: loginViewModel.dialogEntity.message,
                confirmButtonText: loginViewModel.dialogEntity.confirmButtonText,
                dismissButtonText: loginViewModel.dialogEntity.dismissButtonText,
                imageName: loginViewModel.dialogEntity.icon,
                onDismiss: {
                    if let onDismiss = loginViewModel.dialogEntity.onDismiss {
                        onDismiss()
                    }
                },
                onConfirmation: {
                    if let onConfirm = loginViewModel.dialogEntity.onConfirm {
                        onConfirm()
                    }
                }
            )
        }
        .background(Color.theme.surfaceColor)
        .ignoresSafeArea(edges: .all)
        .fullScreenProgressOverlay(isShowing: loginViewModel.loginState == .isLoading )
    }
}


#Preview {
    LoginView(
        onLoginSuccess: {},
        onLoginFailure: {_ in}
    )
}
