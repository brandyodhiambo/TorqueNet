//
//  FontTheme.swift
//  TorqueNet
//
//  Centralized typography helpers for SwiftUI views.
//

import SwiftUI

enum AppFontName {
    // PostScript names (what SwiftUI expects in `.custom(name:size:)`)
    static let exo2Black = "Exo2-Black"
    static let exo2Bold = "Exo2-Bold"
    static let exo2ExtraBold = "Exo2-ExtraBold"
    static let exo2ExtraLight = "Exo2-ExtraLight"
    static let exo2Italic = "Exo2-Italic"
    static let exo2Light = "Exo2-Light"
    static let exo2LightItalic = "Exo2-LightItalic"
    static let exo2Medium = "Exo2-Medium"
    static let exo2Regular = "Exo2-Regular"
    static let exo2SemiBold = "Exo2-SemiBold"
    static let exo2Thin = "Exo2-Thin"
}

struct FontTheme {
    func brand(size: CGFloat) -> Font { .custom(AppFontName.exo2ExtraBold, size: size) }
    func title(size: CGFloat) -> Font { .custom(AppFontName.exo2Bold, size: size) }
    func body(size: CGFloat) -> Font { .custom(AppFontName.exo2Regular, size: size) }
    func bodyMedium(size: CGFloat) -> Font { .custom(AppFontName.exo2Medium, size: size) }
    func caption(size: CGFloat) -> Font { .custom(AppFontName.exo2Regular, size: size) }
}

extension Font {
    static var theme: FontTheme { FontTheme() }
}

