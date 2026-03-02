//
//  ManageAuctionUiState.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

struct ManageAuctionUiState {
    var auctions: [ManageAuctionItem] = []
    var filteredAuctions: [ManageAuctionItem] = []
    var selectedFilter: AuctionStatus? = nil
    
   // var isLoading: Bool = false
    var errorMessage: String = ""
  //  var hasError: Bool = false
    var showError: Bool = false
    var auctionState: FetchState = .good
    var showEditSheet: Bool = false
    var selectedAuction: ManageAuctionItem? = nil
}
