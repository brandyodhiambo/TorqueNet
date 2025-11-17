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
    @Published  var carTitle = ""
    @Published  var subtitle = ""
    @Published  var lotNumber = ""
    @Published  var rating = 4.8
    @Published  var startingBid = ""
    @Published  var auctionEndDate = Date().addingTimeInterval(7 * 24 * 3600)
    @Published  var auctionStatus: UploadAuctionStatus = .upcoming
    
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return selectedImages.count >= 3 && !carTitle.isEmpty && !startingBid.isEmpty
        case 1:
            return true
            //return !make.isEmpty && !model.isEmpty && !year.isEmpty
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
}
