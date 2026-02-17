//
//  FetchScheduledAuctionsUseCase.swift
//  TorqueNet
//
//  Created by MAC on 17/02/2026.
//

class FetchScheduledAuctionsUseCase {
    private let repository: ScheduleAuctionRepository

    init(repository: ScheduleAuctionRepository) {
        self.repository = repository
    }

    func execute() async -> Result<[ScheduledAuction], UploadError> {
        return await repository.fetchScheduledAuctions()
    }
}
