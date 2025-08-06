//
//  InputFieldView.swift
//  TorqueNet
//
//  Created by MAC on 04/08/2025.
//

import SwiftUI

enum InputFieldStyle {
    case filled
    case outlined
}


struct InputFieldView: View {
    var image: String = ""
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
    var onSubmit: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !description.isEmpty {
                Text(description)
                    .font(.custom("Exo2-Medium", size: 15))
                    .foregroundColor(foregroundColor)
                    .padding(.horizontal, 4)
            }

            HStack(spacing: 8) {
                TextField(placeHolder, text: $text)
                    .font(.custom("Exo2-Medium", size: 15))
                    .foregroundColor(foregroundColor)
                    .keyboardType(keyboardType)
                    .autocapitalization(autoCapitalization)
                    .submitLabel(.done)
                    .onSubmit {
                        onSubmit?()
                    }
                    .padding(.vertical, 6)
                
                if !image.isEmpty {
                    Image(image)
                        .renderingMode(.template)
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


  
   struct TappableTextFieldStyle: TextFieldStyle {
       @FocusState private var textFieldFocused: Bool
       func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
               .padding(.vertical)
               //.background(Color.gray)
               .focused($textFieldFocused)
               .onTapGesture {
                   textFieldFocused = true
               }
       }
   }

struct InputFieldViewPreview: View {
    @State var text: String = ""

    var body: some View {
        VStack(spacing: 20) {
            InputFieldView(
                image: "search_icon",
                description: "Username",
                placeHolder: "Enter username",
                text: $text,
                foregroundColor: .black,
                backgroundColor: Color.gray.opacity(0.1),
                inputFieldStyle: .outlined,
                onSubmit: {
                    
                }
            )

            InputFieldView(
                placeHolder: "Email",
                text: $text,
                foregroundColor: .white,
                backgroundColor: .blue.opacity(0.7),
                keyboardType: .emailAddress,
                inputFieldStyle: .outlined
            )
        }
        .padding()
    }
}

#Preview {
    InputFieldViewPreview()
}
