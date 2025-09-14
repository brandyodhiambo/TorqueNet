//
//  CheckboxToggleStyle.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
   func makeBody(configuration: Configuration) -> some View {
       HStack {
           RoundedRectangle(cornerRadius: 5.0)
               .stroke(lineWidth: 2)
               .frame(width: 25, height: 25)
               .cornerRadius(5.0)
               .overlay {
                   Image(systemName: configuration.isOn ?"checkmark" : "")
                       .foregroundColor(Color.theme.primaryColor)
               }
               .onTapGesture {
                   withAnimation(.spring()) {
                       configuration.isOn.toggle()
                   }
               }
           
           configuration.label
           
       }
   }
}
