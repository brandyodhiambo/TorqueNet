//
//  LiveAuctionUiState.swift
//  TorqueNet
//
//  Created by MAC on 14/01/2026.
//

struct LiveAuctionUiState {
    var searchText = ""
    var selectedCategory = "All"
    var fetchedAuctions: [AuctionUploadModel] = []
    
    var errorMessage: String? = nil
    var showError: Bool = false
    var uploadSuccess: Bool = false
    
    var auctionState: FetchState = .good
    var toast: Toast? = nil
}
