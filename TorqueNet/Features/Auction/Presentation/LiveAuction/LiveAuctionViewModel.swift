//
//  LiveAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 14/01/2026.
//

import Foundation
import SwiftUI

@MainActor
class LiveAuctionViewModel: ObservableObject {
    @Published var liveAuctionUiState = LiveAuctionUiState()
    let auctionUseCase: UploadAuctionUseCase = UploadAuctionUseCase(repository: AuctionUploadRepositoryImpl.shared)
    
    func fetchAuctions(
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        liveAuctionUiState.auctionState = .isLoading
        let result = await auctionUseCase.fetchAuctions()
        switch result {
        case .success(let auctions):
            self.liveAuctionUiState.fetchedAuctions = auctions.filter { $0.auctionStatus == "Ongoing" || $0.auctionStatus == "Completed" }
            liveAuctionUiState.auctionState = .good
            onSuccess()
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            liveAuctionUiState.auctionState = .error(message)
            liveAuctionUiState.errorMessage = message
            liveAuctionUiState.showError = true
            onFailure(message)
        }
    }
    
    func updateSaerchText(_ text: String) {
        self.liveAuctionUiState.searchText = text
    }
    
    func updateSelectedCategory(_ category: String) {
            self.liveAuctionUiState.selectedCategory = category
    }
    
    func refreshAuctions() {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.liveAuctionUiState.fetchedAuctions = liveAuctionUiState.fetchedAuctions.shuffled()
        }
    }
    
    func refreshAuctionsAsync() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            refreshAuctions()
        }
    }
    
    func openAuctionDetail(_ auction: AuctionUploadModel) {
        //print("Opening auction: \(auction.title)")
    }
    
}
