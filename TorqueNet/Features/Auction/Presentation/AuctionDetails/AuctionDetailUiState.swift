//
//  AuctionDetailUiState.swift
//  TorqueNet
//
//  Created by MAC on 14/01/2026.
//

import Foundation

struct AuctionDetailUiState{
    var selectedImageIndex = 0
    var isFavorite = false
    var bidAmount = ""
    var timeRemaining: TimeInterval = 0
    var showBidSheet = false
    var showStatusManagementSheet = false
    var selectedTab = 0
    
    var selectedStatus: String = "Ongoing"
    var selectedHours: Int = 24
    var customDate: Date = Date().addingTimeInterval(86400)
    var useCustomDate: Bool = false
    
    let statusOptions = ["Upcoming", "Ongoing", "Completed", "Featured"]
    let hourOptions = [1, 6, 12, 24, 48, 72]
    
    var fetchedAuction: AuctionUploadModel? = nil
    var fetchedBids:[AuctionBidModel] = []
    
    var errorMessage: String? = nil
    var showError: Bool = false
    var uploadSuccess: Bool = false
    
    var auctionState: FetchState = .good
    var toast: Toast? = nil
}
