//
//  FeaturedAuction.swift
//  TorqueNet
//
//  Created by MAC on 08/09/2025.
//
import Foundation

struct FeaturedAuction: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let currentBid: Double
    let estimatedValue: Double
    let timeRemaining: TimeInterval
    let bidCount: Int
    let isLive: Bool
    let condition: String
}
