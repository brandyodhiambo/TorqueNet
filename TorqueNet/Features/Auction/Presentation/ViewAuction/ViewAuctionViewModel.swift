//
//  ViewAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 12/01/2026.
//

import Foundation

@MainActor
class ViewAuctionViewModel: ObservableObject {
    @Published var viewAuctionUiState = ViewAuctionUiState()
    let auctionUseCase: UploadAuctionUseCase = UploadAuctionUseCase(repository: AuctionUploadRepositoryImpl.shared)
    
    
    
    func fetchAuctions(
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        viewAuctionUiState.auctionState = .isLoading
        let result = await auctionUseCase.fetchAuctions()
        switch result {
        case .success(let auctions):
            self.viewAuctionUiState.fetchedAuctions = auctions
            viewAuctionUiState.auctionState = .good
            onSuccess()
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            viewAuctionUiState.auctionState = .error(message)
            viewAuctionUiState.errorMessage = message
            viewAuctionUiState.showError = true
            onFailure(message)
        }
    }
    
    func updateSaerchText(_ text: String) {
        self.viewAuctionUiState.searchText = text
        //applyFilters()
    }
}
