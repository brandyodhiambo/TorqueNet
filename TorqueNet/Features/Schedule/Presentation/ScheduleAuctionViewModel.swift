//
//  ScheduleAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 17/02/2026.
//

import Foundation


@MainActor
class ScheduledAuctionViewModel: ObservableObject {
    @Published var uiState = ScheduledAuctionUiState()
    let fetchScheduledAuctionsUseCase: FetchScheduledAuctionsUseCase = FetchScheduledAuctionsUseCase(repository: ScheduleAuctionRepositoryImpl.shared)


    func loadScheduledAuctions() async {
        uiState.auctionState = .isLoading
        let result = await fetchScheduledAuctionsUseCase.execute()

        switch result {
        case .success(let auctions):
            uiState.scheduledAuctions = auctions
            uiState.auctionState = .good

        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            uiState.auctionState = .error(message)
            uiState.errorMessage = message
        }
    }
}
