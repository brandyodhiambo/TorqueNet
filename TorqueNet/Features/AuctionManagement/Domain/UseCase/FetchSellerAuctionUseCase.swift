//
//  FetchSellerAuctionUseCase.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

class FetchSellerAuctionsUseCase {
    private let repository: ManageAuctionRepository
    
    init(repository: ManageAuctionRepository) {
        self.repository = repository
    }
    
    func execute(sellerId: String) async -> Result<[ManageAuctionItem], UploadError> {
        return await repository.fetchSellerAuctions(sellerId: sellerId)
    }
}
