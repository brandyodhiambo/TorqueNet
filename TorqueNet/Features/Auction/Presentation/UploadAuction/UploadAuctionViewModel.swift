//
//  UploadAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 17/11/2025.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class AuctionUploadViewModel: ObservableObject {
    // UI State
    @Published var currentStep = 0
    @Published var showingImagePicker = false
    @Published var isUploading = false
    @Published var uploadProgress: Double = 0.0
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var uploadSuccess = false
    @Published var uploadedAuctionId: String?
    @Published var auctionState:FetchState = FetchState.good
    @Published var toast: Toast? = nil
    
    // Form Data
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
    
    let uploadUseCase: UploadAuctionUseCase = UploadAuctionUseCase(repository: AuctionUploadRepositoryImpl.shared)
    
    
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return canProceedFromBasicInfo
        case 1:
            return canProceedFromSpecifications
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
    
    private var canProceedFromBasicInfo: Bool {
        selectedImages.count >= 3 &&
        !carTitle.isEmpty &&
        !subtitle.isEmpty &&
        !lotNumber.isEmpty &&
        !startingBid.isEmpty &&
        Double(startingBid) != nil
    }
    
    private var canProceedFromSpecifications: Bool {
        !year.isEmpty &&
        !mileage.isEmpty &&
        !engine.isEmpty &&
        !transmission.isEmpty
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
    
    func removeFeature(from category: Int, at index: Int) {
        switch category {
        case 0:
            guard index < performanceFeatures.count else { return }
            performanceFeatures.remove(at: index)
        case 1:
            guard index < technologyFeatures.count else { return }
            technologyFeatures.remove(at: index)
        case 2:
            guard index < comfortFeatures.count else { return }
            comfortFeatures.remove(at: index)
        default:
            break
        }
    }
    
    func addHistoryEvent() {
        historyEvents.append(HistoryEventData(date: "", event: "", details: ""))
    }
    
    func removeHistoryEvent(at index: Int) {
        guard index < historyEvents.count else { return }
        historyEvents.remove(at: index)
    }
    
    func submitAuction(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        auctionState = .isLoading
        do {
            
            let auctionId = try await uploadUseCase.execute(
                images: selectedImages,
                carTitle: carTitle,
                subtitle: subtitle,
                lotNumber: lotNumber,
                rating: rating,
                startingBid: startingBid,
                auctionEndDate: auctionEndDate,
                auctionStatus: auctionStatus,
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
                historyEvents: historyEvents,
                exteriorRating: exteriorRating,
                exteriorDetails: exteriorDetails,
                interiorRating: interiorRating,
                interiorDetailsText: interiorDetailsText,
                engineRating: engineRating,
                engineDetails: engineDetails,
                transmissionRating: transmissionRating,
                transmissionDetails: transmissionDetails,
                electronicsRating: electronicsRating,
                electronicsDetails: electronicsDetails
            )
            uploadedAuctionId = auctionId
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetForm()
            }
            auctionState = .good
            onSuccess()
            
        } catch let error as AuctionUploadError {
            auctionState = .error(error.errorDescription?.description ?? "An unexpected error occurred.")
            onFailure(error.errorDescription?.description ?? "An unexpected error occurred.")
        } catch {
            auctionState = .error("An unexpected error occurred: \(error.localizedDescription)")
            onFailure("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
    
    func updateProgress(to value: Double) {
        withAnimation {
            uploadProgress = value
        }
    }
    
    func resetForm() {
        currentStep = 0
        selectedImages = []
        carTitle = ""
        subtitle = ""
        lotNumber = ""
        rating = 4.8
        startingBid = ""
        auctionEndDate = Date().addingTimeInterval(7 * 24 * 3600)
        auctionStatus = .upcoming
        mileage = ""
        year = ""
        engine = ""
        transmission = ""
        make = ""
        model = ""
        drivetrain = ""
        exteriorColor = ""
        interiorColor = ""
        vin = ""
        location = ""
        seller = ""
        performanceFeatures = []
        technologyFeatures = []
        comfortFeatures = []
        historyEvents = []
        exteriorRating = 9.0
        exteriorDetails = ""
        interiorRating = 9.0
        interiorDetailsText = ""
        engineRating = 9.0
        engineDetails = ""
        transmissionRating = 9.0
        transmissionDetails = ""
        electronicsRating = 9.0
        electronicsDetails = ""
        uploadSuccess = false
        uploadedAuctionId = nil
    }
    
    func saveDraft() {
        // Implement draft saving to SwiftData or coreData
        print("Draft saved")
    }
}
