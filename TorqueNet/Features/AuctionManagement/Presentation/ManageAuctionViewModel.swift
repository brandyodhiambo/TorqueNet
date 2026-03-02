//
//  ManageAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation
import FirebaseAuth

@MainActor
class ManageAuctionViewModel: ObservableObject {
    @Published var uiState = ManageAuctionUiState()
    let fetchSellerAuctionsUseCase: FetchSellerAuctionsUseCase = FetchSellerAuctionsUseCase(repository: ManageAuctionRepositoryImpl.shared)
    let updateAuctionUseCase: UpdateAuctionUseCase = UpdateAuctionUseCase(repository: ManageAuctionRepositoryImpl.shared)
    let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
    
    func loadAuctions() async {
        uiState.auctionState = .isLoading
        
        let result = await fetchSellerAuctionsUseCase.execute(sellerId: currentUserId)
        switch result {
        case .success(let auctions):
            uiState.auctions = auctions
            applyFilter()
            
        case .failure(let error):
            uiState.showError = true
            uiState.errorMessage = error.localizedDescription
        }
        uiState.auctionState = .good
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
        uiState.auctionState = .isLoading
        
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
            uiState.showError = true
            uiState.errorMessage = error.localizedDescription
        }
        
        uiState.auctionState = .good
    }
}
