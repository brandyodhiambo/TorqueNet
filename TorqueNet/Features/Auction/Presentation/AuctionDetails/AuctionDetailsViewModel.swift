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
    
    func resetForm() {
        auctionDetailsUiState = AuctionDetailUiState()
    }
}
