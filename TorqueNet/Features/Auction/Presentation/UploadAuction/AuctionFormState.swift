//
//  AuctionFormState.swift
//  TorqueNet
//
//  Created by MAC on 04/12/2025.
//

import UIKit
import SwiftUI

struct AuctionFormState {

    var selectedImages: [UIImage] = []
    var activeImageIndex: Int? = nil
    var carTitle: String = ""
    var subtitle: String = ""
    var lotNumber: String = ""
    var rating: Double = 4.8
    var startingBid: String = ""
    var auctionEndDate: Date = Date().addingTimeInterval(7 * 24 * 3600)
    var auctionStatus: UploadAuctionStatus = .upcoming
    var mileage: String = ""
    var year: String = ""
    var engine: String = ""
    var transmission: String = ""
    var performanceFeatures: [String] = []
    var technologyFeatures: [String] = []
    var comfortFeatures: [String] = []
    var newFeature: String = ""
    var selectedFeatureCategory: Int = 0
    var make: String = ""
    var model: String = ""
    var drivetrain: String = ""
    var exteriorColor: String = ""
    var interiorColor: String = ""
    var vin: String = ""
    var location: String = ""
    var seller: String = ""
    var historyEvents: [HistoryEventData] = []
    var exteriorRating: Double = 9.0
    var exteriorDetails: String = ""
    var interiorRating: Double = 9.0
    var interiorDetailsText: String = ""
    var engineRating: Double = 9.0
    var engineDetails: String = ""
    var transmissionRating: Double = 9.0
    var transmissionDetails: String = ""
    var electronicsRating: Double = 9.0
    var electronicsDetails: String = ""
}

