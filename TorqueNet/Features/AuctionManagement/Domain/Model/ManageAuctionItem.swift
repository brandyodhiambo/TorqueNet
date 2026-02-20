//
//  ManageAuctionItem.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation

struct ManageAuctionItem: Identifiable {
    let id: String
    let carTitle: String
    let imageUrl: String
    let lotNumber: String
    let status: AuctionStatus
    let startDate: Date
    let endDate: Date
    let startingBid: Double
    let currentBid: Double
    let bidCount: Int
    let sellerId: String
    
    init(from model: AuctionUploadModel) {
        self.id = model.id
        self.carTitle = model.carTitle
        self.imageUrl = model.imageUrls.first ?? ""
        self.lotNumber = model.lotNumber
        self.status = AuctionStatus(rawValue: model.auctionStatus) ?? .ongoing
        self.startDate = model.createdAt.dateValue()
        self.endDate = model.auctionEndDate.dateValue()
        self.startingBid = model.startingBid
        self.currentBid = model.currentBid
        self.bidCount = model.bidCount
        self.sellerId = model.seller
    }
}
