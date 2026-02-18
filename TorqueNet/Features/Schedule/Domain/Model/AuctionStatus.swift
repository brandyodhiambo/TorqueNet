//
//  AuctionStatus.swift
//  TorqueNet
//
//  Created by MAC on 16/02/2026.
//

import SwiftUI

enum AuctionStatus: String {
    
    case upcoming = "Upcoming"
    case ongoing = "Ongoing"
    case completed = "Completed"
    case featured = "Featured"
    
    var color: Color {
        switch self {
        case .upcoming: return .gray
        case .ongoing: return .red
        case .completed: return .orange
        case .featured: return .green
        }
    }
}
