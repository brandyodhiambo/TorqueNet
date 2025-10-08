//
//  PasswordInputFieldView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 06/08/2025.
//

import SwiftUI

struct PasswordInputFieldView: View {
    var description: String = ""
    var placeHolder: String = ""
    @Binding var text: String

    var foregroundColor: Color = Color.theme.onSurfaceColor
    var backgroundColor: Color = .clear
    var keyboardType: UIKeyboardType = .default
    var autoCapitalization: UITextAutocapitalizationType = .none
    var dividerColor: Color = Color.theme.onSurfaceColor
    var errorMessage: String = ""
    var inputFieldStyle: InputFieldStyle = InputFieldStyle.outlined
    var cornerRadius: CGFloat = 12
    var height: CGFloat = 56
    var onTextChange: (String) -> Void
    var onSubmit: (() -> Void)? = nil

    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !description.isEmpty {
                Text(description)
                    .font(.custom("Exo2-Medium", size: 15))
                    .foregroundColor(foregroundColor)
                    .padding(.horizontal, 4)
            }

            HStack(spacing: 8) {
                Group {
                    if isSecure {
                        SecureField(placeHolder, text: $text)
                    } else {
                        TextField(placeHolder, text: $text)
                    }
                }
                .font(.custom("Exo2-Medium", size: 15))
                .foregroundColor(foregroundColor)
                .keyboardType(keyboardType)
                .autocapitalization(autoCapitalization)
                .submitLabel(.done)
                .onChange(of: text) { newValue in
                    onTextChange(newValue)
                }
                .onSubmit {
                    onSubmit?()
                }
                .padding(.vertical, 6)

                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(foregroundColor)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: height)
            .background(backgroundColor)
            .overlay(
                Group {
                    if inputFieldStyle == .outlined {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(errorMessage.isEmpty ? Color.theme.onSurfaceColor.opacity(0.5) : Color.theme.errorColor, lineWidth: 0.6)
                    }
                }
            )
            .cornerRadius(cornerRadius)

            if inputFieldStyle == .filled {
                Divider()
                    .frame(height: 0.5)
                    .background(errorMessage.isEmpty ? dividerColor : Color.theme.errorColor)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(Color.theme.errorColor)
                    .padding(.leading, 4)
            }
        }
    }
}


struct PasswordInputFieldViewPreview: View {
    @State var text: String = ""

    var body: some View {
        VStack(spacing: 20) {
            PasswordInputFieldView(
                description: "Password",
                placeHolder: "Enter password",
                text: $text,
                foregroundColor: .black,
                backgroundColor: Color.gray.opacity(0.1),
                inputFieldStyle: .outlined,
                onTextChange: {text in},
                onSubmit: {
                    
                }
            )

            PasswordInputFieldView(
                placeHolder: "Password",
                text: $text,
                foregroundColor: .white,
                backgroundColor: .blue.opacity(0.7),
                keyboardType: .emailAddress,
                inputFieldStyle: .outlined,
                onTextChange: {text in}
            )
        }
        .padding()
    }
}

#Preview {
    PasswordInputFieldViewPreview()
}
