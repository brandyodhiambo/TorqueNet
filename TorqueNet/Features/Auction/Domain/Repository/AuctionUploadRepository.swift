//
//  AuctionUploadRepository.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation
import UIKit

protocol AuctionUploadRepository {
    func uploadImages(_ images: [UIImage], auctionId: String) async  -> Result<[String], AuctionUploadError>
    func createAuction(_ auction: AuctionUploadModel) async  -> Result<String, AuctionUploadError>
    func updateAuction(_ auction: AuctionUploadModel) async -> Result<Bool, AuctionUploadError>
    func deleteAuctionImages(_ imageUrls: [String]) async -> Result<Bool, AuctionUploadError>
}
