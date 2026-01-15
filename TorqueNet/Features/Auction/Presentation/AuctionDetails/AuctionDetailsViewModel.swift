//
//  AuctionDetailsViewModel.swift
//  TorqueNet
//
//  Created by MAC on 14/01/2026.
//

import Foundation

@MainActor
class AuctionDetailsViewModel: ObservableObject {
    @Published var auctionDetailsUiState = AuctionDetailUiState()
}
