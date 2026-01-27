//
//  AuctionDetailsViewModel.swift
//  TorqueNet
//
//  Created by MAC on 14/01/2026.
//

import Foundation

@MainActor
class AuctionDetailsViewModel: ObservableObject {
    @Published var auctionDetailsUiState = AuctionDetailUiState()
    let auctionUseCase:UploadAuctionUseCase = UploadAuctionUseCase(repository: AuctionUploadRepositoryImpl.shared)
    
    var highestBidAmount: Double {
        auctionDetailsUiState.fetchedBids
            .map { $0.bidAmount }
            .max() ?? 0
    }
    
    var sortedBids: [AuctionBidModel] {
        auctionDetailsUiState.fetchedBids
            .sorted { $0.bidTime.dateValue() > $1.bidTime.dateValue() }
    }

    
    func updateBidAmount(value: String) {
        auctionDetailsUiState.bidAmount = value
    }
    
    func fetchAuction(
        auctionId:String,
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        auctionDetailsUiState.auctionState = .isLoading
        let result = await auctionUseCase.fetchAuction(auctionId: auctionId)
        switch result {
        case .success(let auctions):
            self.auctionDetailsUiState.fetchedAuction = auctions
            auctionDetailsUiState.auctionState = .good
            onSuccess()
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            auctionDetailsUiState.auctionState = .error(message)
            auctionDetailsUiState.errorMessage = message
            auctionDetailsUiState.showError = true
            onFailure(message)
        }
    }
    
    func placeBid(
        bidUser:String,
        onSuccess: () -> Void,
        onFailure: (String) -> Void) async {
        
        auctionDetailsUiState.auctionState = .isLoading
        let result = await auctionUseCase.placeBid(bidUser: bidUser, bidAmount: auctionDetailsUiState.bidAmount)

        switch result {
        case .success(let id):
            auctionDetailsUiState.auctionState = .good
            auctionDetailsUiState.uploadSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetForm()
            }
            onSuccess()

        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            auctionDetailsUiState.auctionState = .error(message)
            auctionDetailsUiState.errorMessage = message
            auctionDetailsUiState.showError = true
            onFailure(message)
        }
    }
    
    func fetchBids(
        auctionId: String,
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        auctionDetailsUiState.auctionState = .isLoading
        let result = await auctionUseCase.fetchBids(auctionId: auctionId)
        switch result {
        case .success(let bids):
            self.auctionDetailsUiState.fetchedBids = bids
            auctionDetailsUiState.auctionState = .good
            onSuccess()
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            auctionDetailsUiState.auctionState = .error(message)
            auctionDetailsUiState.errorMessage = message
            auctionDetailsUiState.showError = true
            onFailure(message)
        }
    }
    
    func updateAuctionStatus(
        auctionId: String,
        newStatus: String,
        newEndTime: Date?,
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        auctionDetailsUiState.auctionState = .isLoading
        let result = await auctionUseCase.fetchAuction(auctionId: auctionId)
        switch result {
        case .success(let auction):
            self.auctionDetailsUiState.fetchedAuction = auction
            let updateResult = await auctionUseCase.executeUpdateAuction(auction: auction, auctionId: auctionId, newStatus: newStatus, newEndTime: newEndTime)
            switch updateResult {
            case .success(let bids):
                auctionDetailsUiState.auctionState = .good
                onSuccess()
            case .failure(let error):
                let message = error.errorDescription?.description ?? "An unexpected error occurred."
                auctionDetailsUiState.auctionState = .error(message)
                auctionDetailsUiState.errorMessage = message
                auctionDetailsUiState.showError = true
                onFailure(message)
            }
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            auctionDetailsUiState.auctionState = .error(message)
            auctionDetailsUiState.errorMessage = message
            auctionDetailsUiState.showError = true
            onFailure(message)
        }
        
    }
    
    func resetForm() {
        auctionDetailsUiState = AuctionDetailUiState()
    }
}
