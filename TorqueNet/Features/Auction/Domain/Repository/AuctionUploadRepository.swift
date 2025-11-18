//
//  AuctionUploadRepository.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation
import UIKit

protocol AuctionUploadRepository {
    func uploadImages(_ images: [UIImage], auctionId: String) async throws -> [String]
    func createAuction(_ auction: AuctionUploadModel) async throws -> String
    func updateAuction(_ auction: AuctionUploadModel) async throws
    func deleteAuctionImages(_ imageUrls: [String]) async throws
}
