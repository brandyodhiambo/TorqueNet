//
//  ProfileView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct ProfileView: View {
    var onLogoutSuccess: () -> Void
    var onLogoutFailed: (String) -> Void
    var body: some View {
        Text("Profile screen")
    }
}

#Preview {
    ProfileView(
        onLogoutSuccess: {
            
        },
        onLogoutFailed: {error in
            
        }
    )
}
