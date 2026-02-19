//
//  ScheduleAuctionRepository.swift
//  TorqueNet
//
//  Created by MAC on 17/02/2026.
//

protocol ScheduleAuctionRepository {
    func fetchAuctions() async -> Result<[AuctionUploadModel], UploadError>
    func fetchScheduledAuctions() async -> Result<[ScheduledAuction], UploadError>
}
