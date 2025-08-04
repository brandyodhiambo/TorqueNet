//
//  TextAreaFieldView.swift
//  TorqueNet
//
//  Created by MAC on 04/08/2025.
//

import SwiftUI

struct TextAreaFieldView: View {
    var image: String = ""
    var description: String = ""
    var placeHolder: String = "Write something here..."
    @Binding var text: String
    var foregroundColor: Color = Color.theme.onSurfaceColor
    var keyboardType: UIKeyboardType = .default
    var autoCapitalization: UITextAutocapitalizationType = .none
    var dividerColor: Color = Color.theme.onSurfaceColor
    var errorMessage: String = ""
    var inputFieldStyle: InputFieldStyle = InputFieldStyle.outlined
    
    var body: some View {
        HStack{
            if !image.isEmpty {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(foregroundColor)
                    .frame(width: 20, height: 20)
            }
            
            VStack(alignment: .leading, spacing: 0) {

                if !description.isEmpty {
                    Text(description)
                        .font(.system(size: 12,
                                      weight: .light,
                                      design: .rounded))
                        .foregroundColor(foregroundColor)
                }
                
                TextField(placeHolder, text: $text,axis:.vertical)
                        .textFieldStyle(TappableTextFieldStyle())
                        .keyboardType(keyboardType)
                        .lineLimit(5, reservesSpace: true)
                        .autocapitalization(autoCapitalization)
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundColor(foregroundColor)
                        .padding(.vertical, 1)
                        .onTapGesture {
                            Utils.shared.endEditing() // Hide keyboard
                        }
            }
        }
        
        .padding(.horizontal)
        .overlay(
         Group{
             if inputFieldStyle == .outlined {
                 RoundedRectangle(cornerRadius: 6)
                   .stroke(Color.theme.onSurfaceColor.opacity(0.5), lineWidth: 0.5)
             }
         }
           
       )
        
        if inputFieldStyle == .filled {
            Divider()
                .frame(height: 0.5)
                .background(!errorMessage.isEmpty ? .red : dividerColor)
        }

        
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .font(.system(size: 12,weight: .light, design: .rounded))
                .foregroundColor(Color.red)
                .padding(.top,4)
        }
    }
}

#Preview {
    TextAreaFieldView(
        text:.constant("")
    )
    .padding()
}
