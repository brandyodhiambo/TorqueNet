//
//  RegisterView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var router: Router
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

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
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(){
                        Text("Create Account")
                            .font(.custom("Exo2-Bold", size: 20))
                            .foregroundColor(.theme.primaryColor)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        InputFieldView(
                            description: "First Name",
                            placeHolder: "John",
                            text: $firstName,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .default,
                            inputFieldStyle: .outlined
                        )
                        
                        InputFieldView(
                            description: "Last Name",
                            placeHolder: "Doe",
                            text: $lastName,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .default,
                            inputFieldStyle: .outlined
                        )

                        InputFieldView(
                            description: "Email",
                            placeHolder: "johndoe@gmail.com",
                            text: $email,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .emailAddress,
                            inputFieldStyle: .outlined
                        )
                        
                        InputFieldView(
                            description: "Phone Number",
                            placeHolder: "07---------",
                            text: $phoneNumber,
                            foregroundColor: Color.theme.onSurfaceColor,
                            keyboardType: .numberPad,
                            inputFieldStyle: .outlined
                        )
                        
                        PasswordInputFieldView(
                            description: "Password",
                            placeHolder: "********",
                            text: $password,
                            foregroundColor: Color.theme.onSurfaceColor,
                            inputFieldStyle: .outlined
                        )
                        
                        PasswordInputFieldView(
                            description: "Confirm Password",
                            placeHolder: "********",
                            text: $confirmPassword,
                            foregroundColor: Color.theme.onSurfaceColor,
                            inputFieldStyle: .outlined
                        )


                        CustomButtonView(
                            buttonName:"Sign Up",
                            onTap: {
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
        .background(Color.theme.surfaceColor)
        .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    RegisterView()
}
