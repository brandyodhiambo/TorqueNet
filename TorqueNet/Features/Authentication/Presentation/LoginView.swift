//
//  LoginView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct LoginView: View {
    var onLoginSuccess: () -> Void
    var onLoginFailure: (String) -> Void
    var body: some View {
        Text("Login Screen")
    }
}

#Preview {
    LoginView(
        onLoginSuccess: {},
        onLoginFailure: {_ in}
    )
}
