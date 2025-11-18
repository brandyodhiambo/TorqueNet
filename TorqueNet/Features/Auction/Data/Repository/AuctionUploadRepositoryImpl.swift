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
    private let storageBasePath = "auction_images"
    

    func uploadImages(_ images: [UIImage], auctionId: String) async throws -> [String] {
        var uploadedUrls: [String] = []
        
        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw AuctionUploadError.imageCompressionFailed
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
                    try? await deleteAuctionImages(uploadedUrls)
                }
                throw AuctionUploadError.imageUploadFailed(error.localizedDescription)
            }
        }
        
        return uploadedUrls
    }
    
    func createAuction(_ auction: AuctionUploadModel) async throws -> String {
        do {
            let docRef = FirestoreConstants.AuctionsCollection.document(auction.id)
            try docRef.setData(from: auction)
            return auction.id
        } catch {
            throw AuctionUploadError.firestoreWriteFailed(error.localizedDescription)
        }
    }
    
    func updateAuction(_ auction: AuctionUploadModel) async throws {
        do {
            let docRef = FirestoreConstants.AuctionsCollection.document(auction.id)
            try docRef.setData(from: auction, merge: true)
        } catch {
            throw AuctionUploadError.firestoreUpdateFailed(error.localizedDescription)
        }
    }
    
    func deleteAuctionImages(_ imageUrls: [String]) async throws {
        for urlString in imageUrls {
            guard let url = URL(string: urlString) else { continue }
            
            let storageRef = FirestoreConstants.Storage.reference(forURL: urlString)
            try? await storageRef.delete()
        }
    }
}
