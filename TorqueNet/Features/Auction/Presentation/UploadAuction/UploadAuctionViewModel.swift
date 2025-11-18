//
//  UploadAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 17/11/2025.
//

import Foundation
import UIKit

@MainActor
class UploadAuctionViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var showingImagePicker = false
    @Published var selectedImages: [UIImage] = []
    @Published var activeImageIndex: Int? = nil
    
    // Basic Info
    @Published var carTitle = ""
    @Published var subtitle = ""
    @Published var lotNumber = ""
    @Published var rating = 4.8
    @Published var startingBid = ""
    @Published var auctionEndDate = Date().addingTimeInterval(7 * 24 * 3600)
    @Published var auctionStatus: UploadAuctionStatus = .upcoming
    
    // Key Specs
    @Published var mileage = ""
    @Published var year = ""
    @Published var engine = ""
    @Published var transmission = ""
    
    // Features
    @Published var performanceFeatures: [String] = []
    @Published var technologyFeatures: [String] = []
    @Published var comfortFeatures: [String] = []
    @Published var newFeature = ""
    @Published var selectedFeatureCategory = 0
    
    
    // Vehicle Details
    @Published var make = ""
    @Published var model = ""
    @Published var drivetrain = ""
    @Published var exteriorColor = ""
    @Published var interiorColor = ""
    @Published var vin = ""
    @Published var location = ""
    @Published var seller = ""
    
   
    // History
    @Published var historyEvents: [HistoryEventData] = []
    
    // Inspection
    @Published var exteriorRating = 9.0
    @Published var exteriorDetails = ""
    @Published var interiorRating = 9.0
    @Published var interiorDetailsText = ""
    @Published var engineRating = 9.0
    @Published var engineDetails = ""
    @Published var transmissionRating = 9.0
    @Published var transmissionDetails = ""
    @Published var electronicsRating = 9.0
    @Published var electronicsDetails = ""
    
    let steps = [
        "Images & Basic Info",
        "Specifications",
        "Features",
        "History & Inspection",
        "Review & Submit"
    ]
    
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return selectedImages.count >= 3 && !carTitle.isEmpty && !startingBid.isEmpty
        case 1:
            return !mileage.isEmpty && !engine.isEmpty && !year.isEmpty && !transmission.isEmpty
        case 2:
            return true // Features are optional
        case 3:
            return true // History and inspection are optional
        case 4:
            return true // Review step
        default:
            return false
        }
    }
    
    
    func addImage(image: UIImage) {
        if let index = activeImageIndex, index < selectedImages.count {
            selectedImages[index] = image
        } else {
            selectedImages.append(image)
        }
        activeImageIndex = nil
    }
    
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    func updateCarTitle(value: String) {
        carTitle = value
    }
    
    func updateSubtitle(value: String) {
        subtitle = value
    }
    
    func updateLotNumber(value: String) {
        lotNumber = value
    }
    
    func updateStartingBid(value: String) {
        startingBid = value
    }
    
    func updateRating(value: Double) {
        rating = value
    }
    
    func updateAuctionEndDate(value: Date) {
        auctionEndDate = value
    }
    
    func updateAuctionStatus(value: UploadAuctionStatus) {
        auctionStatus = value
    }
    
    func updateMileage(value: String) {
        mileage = value
    }
    
    func updateYear(value: String) {
        year = value
    }
    
    func updateEngine(value: String) {
        engine = value
    }
    
    func updateTransmission(value: String) {
        transmission = value
    }
    
    func addFeature() {
        guard !newFeature.isEmpty else { return }
        
        switch selectedFeatureCategory {
        case 0:
            performanceFeatures.append(newFeature)
        case 1:
            technologyFeatures.append(newFeature)
        case 2:
            comfortFeatures.append(newFeature)
        default:
            break
        }
        
        newFeature = ""
    }
    
    func updateMake(value: String) {
        make = value
    }
    
    func updateModel(value: String) {
        model = value
    }
    
    func updateDriveTrain(value: String) {
        drivetrain = value
    }
    // exterior, interior,vin,location seller
    func updateExteriorColor(value: String) {
        exteriorColor = value
    }
    
    func updateInteriorColor(value: String) {
        interiorColor = value
    }
    
    func updateVin(value: String) {
        vin = value
    }
    
    func updateLocation(value: String) {
        location = value
    }
    
    func updateSeller(value: String) {
        seller = value
    }
    //history even add to list
    
    func submitAuction() {
        // Handle auction submission
        print("Auction submitted successfully!")
    }
    
   
}
