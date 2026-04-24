//
//  FontTheme.swift
//  TorqueNet
//
//  Centralized typography helpers for SwiftUI views.
//

import SwiftUI

enum AppFontName {
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
    func extraBold(size: CGFloat) -> Font { .custom(AppFontName.exo2ExtraBold, size: size) }
    func bold(size: CGFloat) -> Font { .custom(AppFontName.exo2Bold, size: size) }
    func semiBold(size: CGFloat) -> Font { .custom(AppFontName.exo2SemiBold, size: size) }
    func black(size: CGFloat) -> Font { .custom(AppFontName.exo2Black, size: size) }
    func extraLight(size: CGFloat) -> Font { .custom(AppFontName.exo2ExtraLight, size: size) }
    func light(size: CGFloat) -> Font { .custom(AppFontName.exo2Light, size: size) }
    func lightItalic(size: CGFloat) -> Font { .custom(AppFontName.exo2LightItalic, size: size) }
    func italic(size: CGFloat) -> Font { .custom(AppFontName.exo2Italic, size: size) }
    func regular(size: CGFloat) -> Font { .custom(AppFontName.exo2Regular, size: size) }
    func medium(size: CGFloat) -> Font { .custom(AppFontName.exo2Medium, size: size) }
    func thin(size: CGFloat) -> Font { .custom(AppFontName.exo2Thin, size: size) }
}

extension Font {
    static var theme: FontTheme { FontTheme() }
}

