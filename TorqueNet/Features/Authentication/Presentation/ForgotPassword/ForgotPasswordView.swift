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
    
    @State private var email: String = ""
    
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
                Text("Forgot Password?")
                    .font(.custom("Exo2-Bold", size: 20))
                    .foregroundColor(.theme.primaryColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Enter your email below and we will send you a reset link.")
                    .font(.custom("Exo2-Regular", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                InputFieldView(
                    description: "Email",
                    placeHolder: "johndoe@gmail.com",
                    text: $email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    errorMessage: forgotPasswordViewModel.forgotPasswordErrors["email"] ?? "",
                    inputFieldStyle: .outlined,
                    onTextChange: { text in
                        forgotPasswordViewModel.updateEmail(value: text)
                    }
                )
                
                
                CustomButtonView(
                    buttonName:"Send",
                    isDisabled: !forgotPasswordViewModel.isForgotPasswordEnable,
                    onTap: {
                        Task{
                            await forgotPasswordViewModel.forgotPassword(
                                onSuccess: {
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
                                    
                                }, onFailure:{error in
                                    forgotPasswordViewModel.updateIsShowAlertDialog(value: true)
                                    forgotPasswordViewModel.updateDialogEntity(
                                        value: DialogEntity(
                                            title: "Forgot Password Request Failed.",
                                            message: error,
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
                                }
                            )
                        }
                    }
                )
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
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    ForgotPasswordView()
}
