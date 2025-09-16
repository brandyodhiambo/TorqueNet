//
//  LiveAuction.swift
//  TorqueNet
//
//  Created by MAC on 16/09/2025.
//

import Foundation


struct LiveAuction: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let category: String
    let currentBid: Double
    let bidCount: Int
}
