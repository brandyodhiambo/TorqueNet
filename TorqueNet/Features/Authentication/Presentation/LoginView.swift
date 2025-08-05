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
    
    @EnvironmentObject var router: Router
    var body: some View {
        Button(action: {
            onLoginSuccess()
        }, label: {
            Text("Login Screen")
        })
        
        Button(action:{
            router.push(.register)
        }, label: {
            Text("Dont have an account? Sign Up")
        })
    }
}

#Preview {
    LoginView(
        onLoginSuccess: {},
        onLoginFailure: {_ in}
    )
}
