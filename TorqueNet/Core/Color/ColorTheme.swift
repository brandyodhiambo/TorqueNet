//
//  ColorTheme.swift
//  TorqueNet
//
//  Created by MAC on 04/08/2025.
//

import SwiftUI
import Foundation

struct ColorTheme{
    
        let primaryColor = Color("RedAppColor")
        let onPrimaryColor = Color("WhiteAppColor")
       
        let secondaryColor = Color("LightRedAppColor")
        let onSecondaryColor = Color("WhiteAppColor")
       
        let surfaceColor = Color("InverseBlackAndWhite")
        let onSurfaceColor = Color("BlackAndWhiteColor")
       
        let inverseSurfaceColor = Color("BlackAndWhiteColor")
        let onInverseSurfaceColor = Color("InverseBlackAndWhite")
       
        let errorColor = Color("RedAppColor")
        let onErrorColor = Color("WhiteAppColor")
       
        let successColor = Color("GreenAppColor")
        let warningColor = Color("YellowAppColor")
    
}

extension Color{
    static var theme = ColorTheme()
}
