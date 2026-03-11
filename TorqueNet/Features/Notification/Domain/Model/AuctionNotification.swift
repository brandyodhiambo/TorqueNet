//
//  AuctionNotification.swift
//  TorqueNet
//
//  Created by MAC on 11/03/2026.
//

import Foundation

struct AuctionNotification: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    var isRead: Bool = false
    let bidAmount: Double?
    let auctionId: String
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}


