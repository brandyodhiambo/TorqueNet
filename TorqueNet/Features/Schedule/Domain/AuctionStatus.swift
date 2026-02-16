//
//  AuctionStatus.swift
//  TorqueNet
//
//  Created by MAC on 16/02/2026.
//

import SwiftUI

enum AuctionStatus: String {
    case scheduled = "scheduled"
    case live = "live"
    case ending = "ending soon"
    case ended = "ended"
    
    var color: Color {
        switch self {
        case .scheduled: return .gray
        case .live: return .red
        case .ending: return .orange
        case .ended: return .green
        }
    }
}
