//
//  AuctionUploadModel.swift
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

struct AuctionUploadModel: Identifiable, Codable {
    let id: String
    let imageUrls: [String]
    let carTitle: String
    let subtitle: String
    let lotNumber: String
    let rating: Double
    let startingBid: Double
    let currentBid: Double
    let auctionEndDate: Timestamp
    let startDate: Timestamp
    let endDate: Timestamp
    let auctionStatus: String
    let createdAt: Timestamp
    let updatedAt: Timestamp
    
    // Key Specs
    let mileage: String
    let year: String
    let engine: String
    let transmission: String
    
    // Vehicle Details
    let make: String
    let model: String
    let drivetrain: String
    let exteriorColor: String
    let interiorColor: String
    let vin: String
    let location: String
    let seller: String
    
    // Features
    let performanceFeatures: [String]
    let technologyFeatures: [String]
    let comfortFeatures: [String]
    
    // History
    let historyEvents: [HistoryEventsModel]
    
    // Inspection
    let inspection: InspectionReportModel
    
    // Bidding
    let bidCount: Int
    let bidHistory: [BidRecordModel]
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrls = "image_urls"
        case carTitle = "car_title"
        case subtitle
        case lotNumber = "lot_number"
        case rating
        case startingBid = "starting_bid"
        case currentBid = "current_bid"
        case auctionEndDate = "auction_end_date"
        case startDate = "start_date"
        case endDate = "end_date"
        case auctionStatus = "auction_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mileage
        case year
        case engine
        case transmission
        case make
        case model
        case drivetrain
        case exteriorColor = "exterior_color"
        case interiorColor = "interior_color"
        case vin
        case location
        case seller
        case performanceFeatures = "performance_features"
        case technologyFeatures = "technology_features"
        case comfortFeatures = "comfort_features"
        case historyEvents = "history_events"
        case inspection
        case bidCount = "bid_count"
        case bidHistory = "bid_history"
    }
}
