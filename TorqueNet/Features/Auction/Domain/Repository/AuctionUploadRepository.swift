//
//  AuctionUploadRepository.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation
import UIKit

protocol AuctionUploadRepository {
    func uploadImages(_ images: [UIImage], auctionId: String) async  -> Result<[String], UploadError>
    func createAuction(_ auction: AuctionUploadModel) async  -> Result<String, UploadError>
    func updateAuction(_ auction: AuctionUploadModel) async -> Result<Bool, UploadError>
    func deleteAuctionImages(_ imageUrls: [String]) async -> Result<Bool, UploadError>
    func fetchAuctions() async -> Result<[AuctionUploadModel], UploadError>
    func fetchAuction(auctionId: String) async -> Result<AuctionUploadModel, UploadError>
}
