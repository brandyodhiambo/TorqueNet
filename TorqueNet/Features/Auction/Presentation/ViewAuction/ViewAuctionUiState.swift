//
//  ViewAuctionUiState.swift
//  TorqueNet
//
//  Created by MAC on 12/01/2026.
//

struct ViewAuctionUiState {
    var searchText = ""
    var selectedCategory = 0
    var fetchedAuctions: [AuctionUploadModel] = []
    var filteredAuctions: [AuctionUploadModel] = []
    var isShowingAllCategories: Bool = true
    
    var featuredAuctions: [AuctionUploadModel] = []
    var liveAuctions: [AuctionUploadModel] = []
    var upcomingAuctions: [AuctionUploadModel] = []
    var completedAuctions: [AuctionUploadModel] = []
    
    var errorMessage: String? = nil
    var showError: Bool = false
    var uploadSuccess: Bool = false
    
    var auctionState: FetchState = .good
    var toast: Toast? = nil
}
