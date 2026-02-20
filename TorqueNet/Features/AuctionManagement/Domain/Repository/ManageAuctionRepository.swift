//
//  ManageAuctionRepository.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation

protocol ManageAuctionRepository {
    func fetchSellerAuctions(sellerId: String) async -> Result<[ManageAuctionItem], UploadError>
    func updateAuctionDetails(auctionId: String, status: AuctionStatus, startDate: Date, endDate: Date) async -> Result<Void, UploadError>
}
