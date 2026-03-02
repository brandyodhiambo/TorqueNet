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
    
    func executeCreateAuction(
        images: [UIImage],
        sellerId: String,
        carTitle: String,
        subtitle: String,
        lotNumber: String,
        rating: Double,
        startingBid: String,
        auctionEndDate: Date,
        startDate: Date,
        endDate: Date,
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
    ) async -> Result<String, UploadError> {
        
        guard !images.isEmpty else {
            return .failure(.invalidData("At least one image is required"))
        }
        
        guard images.count >= 3 else {
            return .failure(.invalidData("At least 3 images are required"))
        }
        
        guard !carTitle.isEmpty else {
            return .failure(.invalidData("Car title is required"))
        }
        
        guard let bidAmount = Double(startingBid), bidAmount > 0 else {
            return .failure(.invalidData("Valid starting bid is required"))
        }
        
        let auctionId = UUID().uuidString
        let uploadResult = await repository.uploadImages(images, auctionId: auctionId)
        
        let imageUrls: [String]
        switch uploadResult {
        case .success(let urls):
            imageUrls = urls
        case .failure(let error):
            return .failure(error)
        }
        
        let overallRating = (exteriorRating + interiorRating + engineRating + transmissionRating + electronicsRating) / 5.0
        
        let inspection = InspectionReportModel(
            exterior: InspectionCategoryModel(rating: exteriorRating, details: exteriorDetails),
            interior: InspectionCategoryModel(rating: interiorRating, details: interiorDetailsText),
            engine: InspectionCategoryModel(rating: engineRating, details: engineDetails),
            transmission: InspectionCategoryModel(rating: transmissionRating, details: transmissionDetails),
            electronics: InspectionCategoryModel(rating: electronicsRating, details: electronicsDetails),
            overallRating: overallRating
        )
        
        let history = historyEvents.map {
            HistoryEventsModel(date: $0.date, event: $0.event, details: $0.details)
        }
        
        let auction = AuctionUploadModel(
            id: auctionId,
            imageUrls: imageUrls,
            sellerId: sellerId,
            carTitle: carTitle,
            subtitle: subtitle,
            lotNumber: lotNumber,
            rating: rating,
            startingBid: bidAmount,
            currentBid: bidAmount,
            auctionEndDate: Timestamp(date: auctionEndDate),
            startDate: Timestamp(date: startDate),
            endDate: Timestamp(date: endDate),
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
        
        let createResult = await repository.createAuction(auction)
        
        switch createResult {
        case .success(let documentId):
            return .success(documentId)
            
        case .failure(let error):
            _ = await repository.deleteAuctionImages(imageUrls)
            return .failure(error)
        }
    }
    
    func executeUpdateAuction(
        auction: AuctionUploadModel,
        auctionId: String,
        newStatus: String,
        newEndTime: Date?,
    ) async -> Result<Bool, UploadError> {
        let updatedAuction = AuctionUploadModel(
            id: auctionId,
            imageUrls: auction.imageUrls,
            sellerId: auction.sellerId,
            carTitle: auction.carTitle,
            subtitle: auction.subtitle,
            lotNumber: auction.lotNumber,
            rating: auction.rating,
            startingBid: auction.startingBid,
            currentBid: auction.currentBid,
            auctionEndDate: Timestamp(date: newEndTime ?? Date()),
            startDate: auction.startDate,
            endDate: auction.endDate,
            auctionStatus: newStatus,
            createdAt: auction.createdAt,
            updatedAt: Timestamp(date: Date()),
            mileage: auction.mileage,
            year: auction.year,
            engine: auction.engine,
            transmission: auction.transmission,
            make: auction.make,
            model: auction.model,
            drivetrain: auction.drivetrain,
            exteriorColor: auction.exteriorColor,
            interiorColor: auction.interiorColor,
            vin: auction.vin,
            location: auction.location,
            seller: auction.seller,
            performanceFeatures: auction.performanceFeatures,
            technologyFeatures: auction.technologyFeatures,
            comfortFeatures: auction.comfortFeatures,
            historyEvents: auction.historyEvents,
            inspection: auction.inspection,
            bidCount: auction.bidCount,
            bidHistory: auction.bidHistory
        )
        return await repository.updateAuction(updatedAuction)
    }
    
    func fetchAuctions() async -> Result<[AuctionUploadModel], UploadError> {
        return await repository.fetchAuctions()
    }
    
    func fetchAuction(auctionId: String) async -> Result<AuctionUploadModel, UploadError> {
        return await repository.fetchAuction(auctionId: auctionId)
    }
    
    func placeBid(
        auctionId: String,
        bidUser:String,
        bidAmount:String,
    ) async -> Result<String, UploadError> {
        
        guard let bidAmount = Double(bidAmount), bidAmount > 0 else {
            return .failure(.invalidData("Valid starting bid is required"))
        }
        
        let auctionBidId = UUID().uuidString
        
        let bidAuction = AuctionBidModel(
            id:auctionBidId,
            auctionId: auctionId,
            bidUser:bidUser,
            bidAmount:bidAmount,
            bidTime: Timestamp(date: Date())
        )
        
        let uploadResult = await repository.placeBid(bidAuction)
        
        switch uploadResult {
        case .success(let documentId):
            return .success(documentId)
            
        case .failure(let error):
            return .failure(error)
        }
        
    }
    
    func fetchBids(auctionId: String) async -> Result<[AuctionBidModel], UploadError> {
        return await repository.fetchBids(auctionId: auctionId)
    }
}

