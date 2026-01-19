//
//  AuctionModel.swift
//  TorqueNet
//
//  Created by MAC on 19/01/2026.
//

import FirebaseCore

struct AuctionBidModel: Identifiable, Codable {
    let id: String
    let bidUser: String
    let bidAmount: Double
    let bidTime: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case id
        case bidUser = "bid_user"
        case bidAmount = "bid_amount"
        case bidTime = "bid_time"
    }
    
}
