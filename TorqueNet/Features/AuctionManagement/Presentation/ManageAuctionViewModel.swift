//
//  ManageAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation

@MainActor
class ManageAuctionViewModel: ObservableObject {
    @Published var uiState = ManageAuctionUiState()
    
    private let fetchSellerAuctionsUseCase: FetchSellerAuctionsUseCase
    private let updateAuctionUseCase: UpdateAuctionUseCase
    private let currentUserId: String
    
    init(
        fetchSellerAuctionsUseCase: FetchSellerAuctionsUseCase,
        updateAuctionUseCase: UpdateAuctionUseCase,
        currentUserId: String
    ) {
        self.fetchSellerAuctionsUseCase = fetchSellerAuctionsUseCase
        self.updateAuctionUseCase = updateAuctionUseCase
        self.currentUserId = currentUserId
    }
    
    func loadAuctions() async {
        uiState.isLoading = true
        uiState.hasError = false
        uiState.errorMessage = ""
        
        let result = await fetchSellerAuctionsUseCase.execute(sellerId: currentUserId)
        
        switch result {
        case .success(let auctions):
            uiState.auctions = auctions
            applyFilter()
            
        case .failure(let error):
            uiState.hasError = true
            uiState.errorMessage = error.localizedDescription
        }
        
        uiState.isLoading = false
    }
    
    func filterByStatus(_ status: AuctionStatus?) {
        uiState.selectedFilter = status
        applyFilter()
    }
    
    private func applyFilter() {
        if let filter = uiState.selectedFilter {
            uiState.filteredAuctions = uiState.auctions.filter { $0.status == filter }
        } else {
            uiState.filteredAuctions = uiState.auctions
        }
    }
    
    func selectAuctionForEdit(_ auction: ManageAuctionItem) {
        uiState.selectedAuction = auction
        uiState.showEditSheet = true
    }
    
    func updateAuction(status: AuctionStatus, startDate: Date, endDate: Date) async {
        guard let auctionId = uiState.selectedAuction?.id else { return }
        
        uiState.isLoading = true
        
        let result = await updateAuctionUseCase.execute(
            auctionId: auctionId,
            status: status,
            startDate: startDate,
            endDate: endDate
        )
        
        switch result {
        case .success:
            uiState.showEditSheet = false
            await loadAuctions()
            
        case .failure(let error):
            uiState.hasError = true
            uiState.errorMessage = error.localizedDescription
        }
        
        uiState.isLoading = false
    }
}
