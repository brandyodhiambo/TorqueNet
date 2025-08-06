//
//  TappableTextFieldStyle.swift
//  TorqueNet
//
//  Created by MAC on 06/08/2025.
//

import SwiftUI

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
