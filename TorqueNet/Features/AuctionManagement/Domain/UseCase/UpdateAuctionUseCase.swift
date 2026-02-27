//
//  UpdateAuctionUseCase.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation

class UpdateAuctionUseCase {
    private let repository: ManageAuctionRepository
    
    init(repository: ManageAuctionRepository) {
        self.repository = repository
    }
    
    func execute(auctionId: String, status: AuctionStatus, startDate: Date, endDate: Date) async -> Result<Void, UploadError> {
        if endDate <= startDate {
            return .failure(.invalidData("End date must be after start date"))
        }
        
        if status == .upcoming && startDate <= Date() {
            return .failure(.invalidData("Scheduled auctions must have a future start date"))
        }
        
        return await repository.updateAuctionDetails(
            auctionId: auctionId,
            status: status,
            startDate: startDate,
            endDate: endDate
        )
    }
}
