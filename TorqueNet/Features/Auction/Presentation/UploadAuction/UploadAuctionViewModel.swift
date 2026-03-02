//
//  UploadAuctionViewModel.swift
//  TorqueNet
//
//  Created by MAC on 17/11/2025.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseAuth

@MainActor
class AuctionUploadViewModel: ObservableObject {
    @Published var ui = AuctionUploadUIState()
    @Published var form = AuctionFormState()
    
    let steps = [
        "Images & Basic Info",
        "Specifications",
        "Features",
        "History & Inspection",
        "Review & Submit"
    ]
    
    let uploadUseCase: UploadAuctionUseCase = UploadAuctionUseCase(repository: AuctionUploadRepositoryImpl.shared)
    
    
    var canProceed: Bool {
        switch ui.currentStep {
        case 0: return form.selectedImages.count >= 3 &&
                    !form.carTitle.isEmpty &&
                    !form.subtitle.isEmpty &&
                    !form.lotNumber.isEmpty &&
                    !form.startingBid.isEmpty &&
                    Double(form.startingBid) != nil

        case 1: return !form.year.isEmpty &&
                    !form.mileage.isEmpty &&
                    !form.engine.isEmpty &&
                    !form.transmission.isEmpty
        default:
            return true
        }
    }

    
    private var canProceedFromBasicInfo: Bool {
        form.selectedImages.count >= 3 &&
        !form.carTitle.isEmpty &&
        !form.subtitle.isEmpty &&
        !form.lotNumber.isEmpty &&
        !form.startingBid.isEmpty &&
        Double(form.startingBid) != nil
    }
    
    private var canProceedFromSpecifications: Bool {
        !form.year.isEmpty &&
        !form.mileage.isEmpty &&
        !form.engine.isEmpty &&
        !form.transmission.isEmpty
    }
    
    func addImage(image: UIImage) {
        if let index = form.activeImageIndex, index < form.selectedImages.count {
            form.selectedImages[index] = image
        } else {
            form.selectedImages.append(image)
        }
        form.activeImageIndex = nil
    }
    
    func removeImage(at index: Int) {
        guard index < form.selectedImages.count else { return }
        form.selectedImages.remove(at: index)
    }
    
    func updateCarTitle(value: String) {
        form.carTitle = value
    }
    
    func updateSubtitle(value: String) {
        form.subtitle = value
    }
    
    func updateLotNumber(value: String) {
        form.lotNumber = value
    }
    
    func updateStartingBid(value: String) {
        form.startingBid = value
    }
    
    func updateRating(value: Double) {
        form.rating = value
    }
    
    func updateAuctionEndDate(value: Date) {
        form.auctionEndDate = value
    }
    
    func updateAuctionStatus(value: UploadAuctionStatus) {
        form.auctionStatus = value
    }
    
    func updateMileage(value: String) {
        form.mileage = value
    }
    
    func updateYear(value: String) {
        form.year = value
    }
    
    func updateEngine(value: String) {
        form.engine = value
    }
    
    func updateTransmission(value: String) {
        form.transmission = value
    }
    
    func updateMake(value: String) {
        form.make = value
    }
    
    func updateModel(value: String) {
        form.model = value
    }
    
    func updateDriveTrain(value: String) {
        form.drivetrain = value
    }
    // exterior, interior,vin,location seller
    func updateExteriorColor(value: String) {
        form.exteriorColor = value
    }
    
    func updateInteriorColor(value: String) {
        form.interiorColor = value
    }
    
    func updateVin(value: String) {
        form.vin = value
    }
    
    func updateLocation(value: String) {
        form.location = value
    }
    
    func updateSeller(value: String) {
        form.seller = value
    }
    
    
    func addFeature() {
        guard !form.newFeature.isEmpty else { return }
        
        switch form.selectedFeatureCategory {
        case 0:
            form.performanceFeatures.append(form.newFeature)
        case 1:
            form.technologyFeatures.append(form.newFeature)
        case 2:
            form.comfortFeatures.append(form.newFeature)
        default:
            break
        }
        
        form.newFeature = ""
    }
    
    func removeFeature(from category: Int, at index: Int) {
        switch category {
        case 0:
            guard index < form.performanceFeatures.count else { return }
            form.performanceFeatures.remove(at: index)
        case 1:
            guard index < form.technologyFeatures.count else { return }
            form.technologyFeatures.remove(at: index)
        case 2:
            guard index < form.comfortFeatures.count else { return }
            form.comfortFeatures.remove(at: index)
        default:
            break
        }
    }
    
    func addHistoryEvent() {
        form.historyEvents.append(HistoryEventData(date: "", event: "", details: ""))
    }
    
    func removeHistoryEvent(at index: Int) {
        guard index < form.historyEvents.count else { return }
        form.historyEvents.remove(at: index)
    }
    
    func submitAuction(onSuccess: () -> Void, onFailure: (String) -> Void) async {
        
        ui.auctionState = .isLoading
        
        let result = await uploadUseCase.executeCreateAuction(
            images: form.selectedImages,
            sellerId: Auth.auth().currentUser?.uid ?? "",
            carTitle: form.carTitle,
            subtitle: form.subtitle,
            lotNumber: form.lotNumber,
            rating: form.rating,
            startingBid: form.startingBid,
            auctionEndDate: form.auctionEndDate,
            startDate: form.startDate,
            endDate: form.endDate,
            auctionStatus: form.auctionStatus,
            mileage: form.mileage,
            year: form.year,
            engine: form.engine,
            transmission: form.transmission,
            make: form.make,
            model: form.model,
            drivetrain: form.drivetrain,
            exteriorColor: form.exteriorColor,
            interiorColor: form.interiorColor,
            vin: form.vin,
            location: form.location,
            seller: form.seller,
            performanceFeatures: form.performanceFeatures,
            technologyFeatures: form.technologyFeatures,
            comfortFeatures: form.comfortFeatures,
            historyEvents: form.historyEvents,
            exteriorRating: form.exteriorRating,
            exteriorDetails: form.exteriorDetails,
            interiorRating: form.interiorRating,
            interiorDetailsText: form.interiorDetailsText,
            engineRating: form.engineRating,
            engineDetails: form.engineDetails,
            transmissionRating: form.transmissionRating,
            transmissionDetails: form.transmissionDetails,
            electronicsRating: form.electronicsRating,
            electronicsDetails: form.electronicsDetails
        )

        switch result {
        case .success(let id):
            ui.auctionState = .good
            ui.uploadSuccess = true
            ui.uploadSuccess = true
            ui.showError = false
            ui.errorMessage = nil

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetForm()
            }
            onSuccess()

        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            ui.auctionState = .error(message)
            ui.errorMessage = message
            ui.showError = true
            onFailure(message)
        }
    }


    
    func updateProgress(to value: Double) {
        withAnimation {
            ui.uploadProgress = value
        }
    }
    
    func resetForm() {
        ui = AuctionUploadUIState()
        form = AuctionFormState()
    }
    
    func validateSchedule() {
        form.scheduleError = ""
            
        if form.startDate <= Date() {
            form.scheduleError = "Start date must be in the future"
                return
            }
            
        let oneHourFromNow = Date().addingTimeInterval(3600)
        if form.startDate < oneHourFromNow {
            form.scheduleError = "Start date must be at least 1 hour from now"
                return
            }
            
        if form.endDate <= form.startDate {
            form.scheduleError = "End date must be after start date"
                return
            }
            
        if !form.startingBid.isEmpty {
            if let bid = Double(form.startingBid), bid <= 0 {
                form.scheduleError = "Starting bid must be greater than 0"
                    return
            } else if Double(form.startingBid) == nil {
                form.scheduleError = "Please enter a valid starting bid"
                    return
                }
            }
        }
        

    
    func saveDraft() {
        // Implement draft saving to SwiftData or coreData
        print("Draft saved")
    }
}
