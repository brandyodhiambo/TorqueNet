//
//  UploadAuctionUseCase.swift
//  TorqueNet
//
//  Created by MAC on 19/11/2025.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class UploadAuctionUseCase {
    private let repository: AuctionUploadRepository
    
    init(repository: AuctionUploadRepository) {
        self.repository = repository
    }
    
    func execute(
        images: [UIImage],
        carTitle: String,
        subtitle: String,
        lotNumber: String,
        rating: Double,
        startingBid: String,
        auctionEndDate: Date,
        auctionStatus: UploadAuctionStatus,
        mileage: String,
        year: String,
        engine: String,
        transmission: String,
        make: String,
        model: String,
        drivetrain: String,
        exteriorColor: String,
        interiorColor: String,
        vin: String,
        location: String,
        seller: String,
        performanceFeatures: [String],
        technologyFeatures: [String],
        comfortFeatures: [String],
        historyEvents: [HistoryEventData],
        exteriorRating: Double,
        exteriorDetails: String,
        interiorRating: Double,
        interiorDetailsText: String,
        engineRating: Double,
        engineDetails: String,
        transmissionRating: Double,
        transmissionDetails: String,
        electronicsRating: Double,
        electronicsDetails: String
    ) async throws -> String {
        
        guard !images.isEmpty else {
            throw AuctionUploadError.invalidData("At least one image is required")
        }
        
        guard images.count >= 3 else {
            throw AuctionUploadError.invalidData("At least 3 images are required")
        }
        
        guard !carTitle.isEmpty else {
            throw AuctionUploadError.invalidData("Car title is required")
        }
        
        guard let bidAmount = Double(startingBid), bidAmount > 0 else {
            throw AuctionUploadError.invalidData("Valid starting bid is required")
        }
        
        let auctionId = UUID().uuidString
        
        let imageUrls = try await repository.uploadImages(images, auctionId: auctionId)
        
        let overallRating = (exteriorRating + interiorRating + engineRating + transmissionRating + electronicsRating) / 5.0
        
        let inspection = InspectionReportModel(
            exterior: InspectionCategoryModel(rating: exteriorRating, details: exteriorDetails),
            interior: InspectionCategoryModel(rating: interiorRating, details: interiorDetailsText),
            engine: InspectionCategoryModel(rating: engineRating, details: engineDetails),
            transmission: InspectionCategoryModel(rating: transmissionRating, details: transmissionDetails),
            electronics: InspectionCategoryModel(rating: electronicsRating, details: electronicsDetails),
            overallRating: overallRating
        )
        
        let history = historyEvents.map { event in
            HistoryEventsModel(date: event.date, event: event.event, details: event.details)
        }
        
        // Create auction model
        let auction = AuctionUploadModel(
            id: auctionId,
            imageUrls: imageUrls,
            carTitle: carTitle,
            subtitle: subtitle,
            lotNumber: lotNumber,
            rating: rating,
            startingBid: bidAmount,
            currentBid: bidAmount,
            auctionEndDate: Timestamp(date: auctionEndDate),
            auctionStatus: auctionStatus.rawValue,
            createdAt: Timestamp(date: Date()),
            updatedAt: Timestamp(date: Date()),
            mileage: mileage,
            year: year,
            engine: engine,
            transmission: transmission,
            make: make,
            model: model,
            drivetrain: drivetrain,
            exteriorColor: exteriorColor,
            interiorColor: interiorColor,
            vin: vin,
            location: location,
            seller: seller,
            performanceFeatures: performanceFeatures,
            technologyFeatures: technologyFeatures,
            comfortFeatures: comfortFeatures,
            historyEvents: history,
            inspection: inspection,
            bidCount: 0,
            bidHistory: []
        )
        
        // Upload to Firestore
        do {
            let documentId = try await repository.createAuction(auction)
            return documentId
        } catch {
            // If Firestore upload fails, delete uploaded images
            try? await repository.deleteAuctionImages(imageUrls)
            throw error
        }
    }
}
