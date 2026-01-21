//
//  AuctionUploadRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class AuctionUploadRepositoryImpl: AuctionUploadRepository {
    static let shared = AuctionUploadRepositoryImpl()
    private let storageBasePath = "auction_images"
    
    
    func uploadImages(_ images: [UIImage], auctionId: String) async -> Result<[String], UploadError> {
        var uploadedUrls: [String] = []

        for (index, image) in images.enumerated() {

            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return .failure(.imageCompressionFailed)
            }

            let imageName = "\(auctionId)_\(index)_\(UUID().uuidString).jpg"
            let storageRef = FirestoreConstants.StorageRef.child("\(storageBasePath)/\(imageName)")

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            do {
                _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
                let downloadUrl = try await storageRef.downloadURL()
                uploadedUrls.append(downloadUrl.absoluteString)

            } catch {
                if !uploadedUrls.isEmpty {
                    await deleteImagesOnFailure(urls: uploadedUrls)
                }
                return .failure(.imageUploadFailed(error.localizedDescription))
            }
        }

        return .success(uploadedUrls)
    }
    
    private func deleteImagesOnFailure(urls: [String]) async {
        for url in urls {
            if let ref = try? Storage.storage().reference(forURL: url) {
                try? await ref.delete()
            }
        }
    }

    func createAuction(_ auction: AuctionUploadModel) async -> Result<String, UploadError> {
        do {
            let docRef = FirestoreConstants.AuctionsCollection.document(auction.id)
            try docRef.setData(from: auction)
            return .success(auction.id)
        } catch {
            return .failure(.firestoreWriteFailed(error.localizedDescription))
        }
    }

    func updateAuction(_ auction: AuctionUploadModel) async -> Result<Bool, UploadError> {
        do {
            let docRef = FirestoreConstants.AuctionsCollection.document(auction.id)
            try await docRef.setData(from: auction, merge: true)
            return .success(true)
        } catch {
            return .failure(.firestoreUpdateFailed(error.localizedDescription))
        }
    }

    
    func deleteAuctionImages(_ imageUrls: [String]) async -> Result<Bool, UploadError> {
        for urlString in imageUrls {
            let storageRef = FirestoreConstants.FirebaseStorage.reference(forURL: urlString)

            do {
                try await storageRef.delete()
            } catch {
                return .failure(.storageDeleteFailed(error.localizedDescription))
            }
        }
        
        return .success(true)
    }
    
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
    
    func fetchAuction(auctionId: String) async -> Result<AuctionUploadModel, UploadError>{
        do {
            let snapshot = try await FirestoreConstants.AuctionsCollection
                .document(auctionId)
                .getDocument()
            
            guard snapshot.exists else {
                return .failure(.firestoreFetchFailed("Auction not found", "auctions"))
            }
            
            let auction: AuctionUploadModel = try! snapshot.data(as: AuctionUploadModel.self)
            
            return .success(auction)

        } catch {
            return .failure(
                .firestoreFetchFailed(error.localizedDescription, "auctions")
            )
        }
    }
    
    func placeBid(_ auctionBid: AuctionBidModel) async -> Result<String, UploadError> {
        do {
            let docRef = FirestoreConstants.BidsCollection.document(auctionBid.id)
            try docRef.setData(from: auctionBid)
            return .success(auctionBid.id)
        } catch {
            return .failure(.firestoreWriteFailed(error.localizedDescription))
        }
    }
    
    func fetchBids() async -> Result<[AuctionBidModel], UploadError> {
        do {
            let snapshot = try await FirestoreConstants.BidsCollection
                .getDocuments()

            let auctionBids: [AuctionBidModel] = snapshot.documents.compactMap { document in
                try? document.data(as: AuctionBidModel.self)
            }

            return .success(auctionBids)

        } catch {
            return .failure(
                .firestoreFetchFailed(error.localizedDescription, "bids")
            )
        }
    }
    
}
