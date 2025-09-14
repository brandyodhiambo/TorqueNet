//
//  ForgotPasswordView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 07/08/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var router: Router
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
                    inputFieldStyle: .outlined
                )
                

                CustomButtonView(
                    buttonName:"Send",
                    onTap: {
                        router.push(.login)
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
