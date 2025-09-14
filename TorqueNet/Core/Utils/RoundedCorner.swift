//
//  RoundedCorner.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 06/08/2025.
//
import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = CGFloat.infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


