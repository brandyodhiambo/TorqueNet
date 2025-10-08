//
//  ToastView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation
import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: () -> Void
    
    var body: some View {
        HStack( alignment: .center, spacing: 12){
            Image(systemName: style.iconFileName)
                .foregroundStyle(style.themeColor)
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.black)

            Spacer(minLength: 10)
            
            Button{
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.white)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style.themeColor, lineWidth: 2)
        }
        .padding(.horizontal, 16)
    }
}
