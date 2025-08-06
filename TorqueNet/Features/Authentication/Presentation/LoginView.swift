//
//  LoginView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

//struct LoginView: View {
//  
//    var body: some View {
//           ZStack(alignment: .bottom) {
//               // Background color
//               Color.theme.surfaceColor
//                   .ignoresSafeArea()
//
//               // Top content: App name and car image
//               VStack(alignment: .center, spacing: 24) {
//                   Spacer(minLength: 60)
//
//                   Text("TorqueNet")
//                       .font(.custom("Exo2-ExtraBold", size: 32))
//                       .foregroundColor(.theme.primaryColor)
//
//                   Spacer()
//
//                   HStack {
//                       Spacer()
//                       Image("appCar")
//                           .resizable()
//                           .scaledToFit()
//                           .frame(width: 140, height: 140)
//                           .rotationEffect(.degrees(25))
//                           .offset(x: 20, y: 0)
//                   }
//               }
//               .padding(.horizontal)
//               .frame(maxHeight: .infinity, alignment: .top)
//
//               // Bottom card for input / buttons
//               VStack(spacing: 24) {
//                   Button(action: {
//                       onLoginSuccess()
//                   }) {
//                       Text("Login Screen")
//                           .font(.headline)
//                           .padding()
//                           .frame(maxWidth: .infinity)
//                           .background(Color.theme.primaryColor)
//                           .foregroundColor(.white)
//                           .cornerRadius(12)
//                   }
//
//                   Button(action: {
//                       router.push(.register)
//                   }) {
//                       Text("Don't have an account? Sign Up")
//                           .font(.subheadline)
//                           .foregroundColor(.theme.onSurfaceColor)
//                   }
//               }
//               .padding(24)
//               .frame(maxWidth: .infinity)
//               .background(
//                   Color.theme.successColor
//                       .clipShape(RoundedCorner(radius: 60, corners: [.topLeft, .topRight]))
//               )
//               .edgesIgnoringSafeArea(.bottom)
//           }
//       }
//}

struct LoginView: View {
    var onLoginSuccess: () -> Void
    var onLoginFailure: (String) -> Void
    @EnvironmentObject var router: Router
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false

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
                    text: $email,
                    foregroundColor: Color.theme.onSurfaceColor,
                    keyboardType: .emailAddress,
                    inputFieldStyle: .outlined
                )

                HStack {
                    Image(systemName: "lock")
                    SecureField("Enter Your Password", text: $password)
                    Spacer()
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )

                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember me")
                            .font(.custom("Exo2-Medium", size: 15))
                            .foregroundColor(Color.theme.primaryColor)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(Color.theme.onSurfaceColor)

                    Spacer()
                    Button("Forgot Password?") {
                        // Action
                    }
                    .foregroundColor(.theme.primaryColor)
                    .font(.custom("Exo2-Medium", size: 15))
                }

                CustomButtonView(
                    buttonName:"Sign In",
                    onTap: {
                        onLoginSuccess()
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
            .padding(.vertical, 40)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color.theme.onSurfaceColor.opacity(0.2))
                    .clipShape(RoundedCorner(radius: 45, corners: [.topLeft, .topRight]))
                    .frame(maxWidth: .infinity, maxHeight: 900)
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
        .background(Color.theme.surfaceColor)
        .ignoresSafeArea(edges: .all)
    }
}


#Preview {
    LoginView(
        onLoginSuccess: {},
        onLoginFailure: {_ in}
    )
}
