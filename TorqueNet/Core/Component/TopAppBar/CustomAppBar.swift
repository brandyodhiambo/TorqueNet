//
//  CustomAppBar.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//


import SwiftUI

struct CustomTopAppBar<Content: View>: ViewModifier {
    let title: String
    let leadingIcon: String?
    let navbarTitleDisplayMode: NavigationBarItem.TitleDisplayMode
    let onLeadingTap: (() -> Void)?
    let trailingIcon: String?
    let onTrailingTap: (() -> Void)?
    var trailingMenu: Content? = nil

    func body(content: Self.Content) -> some View {
        content
            .toolbar {
                // Leading icon
                if let leadingIcon = leadingIcon {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            onLeadingTap?()
                        }) {
                            Image(systemName: leadingIcon)
                                .foregroundColor(Color.theme.primaryColor)
                        }
                    }
                }

                // Trailing icon button
                if let trailingIcon = trailingIcon {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            onTrailingTap?()
                        }) {
                            Image(systemName: trailingIcon)
                                .foregroundColor(Color.theme.primaryColor)
                        }
                    }
                }

                // Trailing menu (custom content)
                if let trailingMenu = trailingMenu {
                    ToolbarItem(placement: .topBarTrailing) {
                        trailingMenu
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(navbarTitleDisplayMode)
    }
}


struct TopAppBar_Previews: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Hello Lets See")
                    .customTopAppBar(
                        title: "My Screen",
                        leadingIcon: "chevron.backward",
                        navbarTitleDisplayMode: .inline,
                        onLeadingTap: {
                            print("Back tapped")
                        },
                        trailingIcon: "gear",
                        onTrailingTap: {
                            print("Settings tapped")
                        },
                        trailingMenu: {}
                    )
            }
        }
    }
   
}


#Preview {
    TopAppBar_Previews()

}
