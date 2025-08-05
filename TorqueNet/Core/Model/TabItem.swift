//
//  TabItemEntity.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import Foundation
import SwiftUI

enum TabItem: Int, CaseIterable{
    case home = 0
    case auction
    case wishlist
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .auction:
            return "Auctions"
        case .wishlist:
            return "Wishlist"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .auction:
            return "wallet.bifold.fill"
        case .wishlist:
            return "heart.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return Color.orange
        case .wishlist:
            return Color.green
        case .auction:
            return Color.blue
        case .settings:
            return Color.cyan
        }
    }
}
