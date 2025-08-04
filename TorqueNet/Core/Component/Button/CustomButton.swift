//
//  CustomButton.swift
//  TorqueNet
//
//  Created by MAC on 04/08/2025.
//

import SwiftUI

struct CustomButtonView: View {
      var buttonName: String
      var width: Double = .infinity
      var height: Double = 50
      var leadingIcon: String=""
      var leadingimage: String=""
      var icon: String=""
      var image: String=""
      var foregroundStyle: Color = Color.theme.onPrimaryColor
      var backgroundColor: Color = Color.theme.primaryColor
      var borderColor: Color = Color.theme.primaryColor
      var buttonNameColor: Color = Color.theme.onPrimaryColor
      var isDisabled: Bool = false
      var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                if(!leadingIcon.isEmpty){
                    Image(systemName: leadingIcon)
                }
                
                if(!leadingimage.isEmpty){
                    Image(leadingimage)
                }
                
                Text(buttonName)
                    .font(.custom("Exo2-Regular", size: 15))
                    .foregroundColor(buttonNameColor)
                
                if(!icon.isEmpty){
                    Image(systemName: icon)
                }
                
                if(!image.isEmpty){
                    Image(image)
                }
                
            }
            .foregroundColor(foregroundStyle)
            .frame(maxWidth: width, maxHeight: height)
            .frame(height: height) // Solve the maxHeight issue
        }
        .background(isDisabled ? Color.gray : backgroundColor)
        .disabled(isDisabled)
        .cornerRadius(7)
        .overlay(
               RoundedRectangle(cornerRadius: 7)
                   .stroke(borderColor, lineWidth: 1)
           )


    }
}

#Preview {
    CustomButtonView(
        buttonName:"Primary Button",
        onTap: { }
    )
    .padding()
}
