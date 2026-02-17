//
//  ScheduledAuctionUiState.swift
//  TorqueNet
//
//  Created by MAC on 17/02/2026.
//

import Foundation

struct ScheduledAuctionUiState {
    var scheduledAuctions: [ScheduledAuction] = []
    var selectedDate = Date()
    var currentMonth = Date()
    var showingDayDetail = false
    var selectedDayAuctions: [ScheduledAuction] = []
    
    var errorMessage: String? = nil
    var showError: Bool = false
    var uploadSuccess: Bool = false
    var auctionState: FetchState = .good
    var toast: Toast? = nil
}
