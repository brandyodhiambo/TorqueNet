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
            applyFilters()
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
        applyFilters()
    }
    
    func updateSelectedCategory(_ index: Int) {
            self.viewAuctionUiState.selectedCategory = index
            applyFilters()
        }
    
    func applyFilters() {
            var filtered = viewAuctionUiState.fetchedAuctions
            
            let categories = ["All", "Upcoming", "Ongoing", "Completed", "Featured"]
            let selectedCategory = categories[viewAuctionUiState.selectedCategory]
        
           viewAuctionUiState.isShowingAllCategories = selectedCategory == "All"
            
            if selectedCategory != "All" {
                filtered = filtered.filter { auction in
                    switch selectedCategory {
                    case "Upcoming":
                        return auction.auctionStatus == "Upcoming"
                    case "Ongoing":
                        return auction.auctionStatus == "Ongoing"
                    case "Completed":
                        return auction.auctionStatus == "Completed"
                    case "Featured":
                        return auction.auctionStatus == "Featured"
                    default:
                        return true
                    }
                }
            }
            
            if !viewAuctionUiState.searchText.isEmpty {
                filtered = filtered.filter { auction in
                    auction.carTitle.localizedCaseInsensitiveContains(viewAuctionUiState.searchText) ||
                    (auction.subtitle.localizedCaseInsensitiveContains(viewAuctionUiState.searchText))
                }
            }
            
            viewAuctionUiState.filteredAuctions = filtered
            
            viewAuctionUiState.featuredAuctions = filtered.filter { $0.auctionStatus == "Featured" }
            viewAuctionUiState.liveAuctions = filtered.filter { $0.auctionStatus == "Ongoing" }
            viewAuctionUiState.upcomingAuctions = filtered.filter { $0.auctionStatus == "Upcoming" }
            viewAuctionUiState.completedAuctions = filtered.filter { $0.auctionStatus == "Completed" }
        }
}
