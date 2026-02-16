//
//  ScheduledAuction.swift
//  TorqueNet
//
//  Created by MAC on 16/02/2026.
//

import Foundation

struct ScheduledAuction: Identifiable {
    let id:String = ""
    let title: String
    let startDate: Date
    let endDate: Date?
    let startingBid: Double?
    let status: AuctionStatus
    let imageName: String
}

