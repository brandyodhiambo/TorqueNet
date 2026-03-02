//
//  ManageAuctionRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import Foundation
import FirebaseCore

class ManageAuctionRepositoryImpl: ManageAuctionRepository {
    static let shared = ManageAuctionRepositoryImpl()
    
    func fetchSellerAuctions(sellerId: String) async -> Result<[ManageAuctionItem], UploadError> {
        do {
            let snapshot = try await FirestoreConstants.AuctionsCollection
                .whereField("seller_id", isEqualTo: sellerId)
                .getDocuments()
            
            let auctions: [ManageAuctionItem] = snapshot.documents.compactMap { document in
                guard let model = try? document.data(as: AuctionUploadModel.self) else {
                    return nil
                }
                return ManageAuctionItem(from: model)
            }
            
            return .success(auctions)
            
        } catch {
            return .failure(
                .firestoreFetchFailed(error.localizedDescription, "seller auctions")
            )
        }
    }
    
    func updateAuctionDetails(auctionId: String, status: AuctionStatus, startDate: Date, endDate: Date) async -> Result<Void, UploadError> {
        do {
            let updateData: [String: Any] = [
                "auction_status": status.rawValue,
                "created_at": Timestamp(date: startDate),
                "auction_end_date": Timestamp(date: endDate),
                "updated_at": Timestamp(date: Date())
            ]
            
            try await FirestoreConstants.AuctionsCollection
                .document(auctionId)
                .updateData(updateData)
            
            return .success(())
            
        } catch {
            return .failure(.firestoreUpdateFailed(error.localizedDescription))
        }
    }
}
