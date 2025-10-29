//
//  View.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//

import SwiftUI



extension View {
    func customTopAppBar<Content: View>(
        title: String,
        leadingIcon: String? = nil,
        navbarTitleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline,
        onLeadingTap: (() -> Void)? = nil,
        trailingIcon: String? = nil,
        onTrailingTap: (() -> Void)? = nil,
        @ViewBuilder trailingMenu: () -> Content? = { nil }
    ) -> some View {
        self.modifier(CustomTopAppBar(
            title: title,
            leadingIcon: leadingIcon,
            navbarTitleDisplayMode: navbarTitleDisplayMode,
            onLeadingTap: onLeadingTap,
            trailingIcon: trailingIcon,
            onTrailingTap: onTrailingTap,
            trailingMenu: trailingMenu()
        ))
    }
    
    func fullScreenProgressOverlay(isShowing: Bool, text: String = "Loading...") -> some View {
        self.overlay(
            Group {
                if isShowing {
                    Color(white: 0, opacity: 0.5)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .overlay(
                            VStack {
                                ProgressView(text)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                                .padding()
                                .background(Color(white: 0.2, opacity: 0.7))
                                .cornerRadius(12)
                        )
                }
            },
            alignment: .center
        )
    }
    
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
