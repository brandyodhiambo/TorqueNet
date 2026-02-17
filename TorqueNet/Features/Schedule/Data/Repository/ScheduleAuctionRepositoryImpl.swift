//
//  ScheduleAuctionRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 17/02/2026.
//

class ScheduleAuctionRepositoryImpl: ScheduleAuctionRepository {
    func fetchAuctions() async -> Result<[AuctionUploadModel], UploadError> {
        do {
            let snapshot = try await FirestoreConstants.AuctionsCollection
                .getDocuments()

            let auctions: [AuctionUploadModel] = snapshot.documents.compactMap { document in
                try? document.data(as: AuctionUploadModel.self)
            }

            return .success(auctions)

        } catch {
            return .failure(
                .firestoreFetchFailed(error.localizedDescription, "auctions")
            )
        }
    }
    
       func fetchScheduledAuctions() async -> Result<[ScheduledAuction], UploadError> {
           let result = await fetchAuctions()

           switch result {
           case .success(let auctions):
               let scheduled = auctions
                   .filter { $0.auctionStatus.lowercased() == AuctionStatus.scheduled.rawValue }
                   .compactMap { mapToScheduledAuction($0) }

               return .success(scheduled)

           case .failure(let error):
               return .failure(error)
           }
       }


       private func mapToScheduledAuction(_ model: AuctionUploadModel) -> ScheduledAuction? {
           guard let status = AuctionStatus(rawValue: model.auctionStatus.lowercased()) else {
               return nil
           }

           return ScheduledAuction(
               id: model.id,
               title: model.carTitle,
               startDate: model.startDate.dateValue(),
               endDate: model.endDate.dateValue(),
               startingBid: model.startingBid,
               status: status,
               imageName: model.imageUrls.first ?? ""
           )
       }
}
