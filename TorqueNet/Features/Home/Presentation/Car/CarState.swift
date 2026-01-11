//
//  CarState.swift
//  TorqueNet
//
//  Created by MAC on 08/12/2025.
//

import SwiftUI
import PhotosUI

struct CarUiState{
    var carName = ""
    var carModel = ""
    var carCondition = ""
    var isNewCar: Bool = false
    var rating = 4.8
    var numberOfReviews = ""
    var ownerName = ""
    var ownerRole = ""
    var passengers = ""
    var doors = ""
    var hasAirConditioner = true
    var fuelPolicy = "Full to Full"
    var transmission = "Manual"
    var maxPower = ""
    var zeroToSixty = ""
    var topSpeed = ""
    var fetchedCars: [CarModel] = []
    var filteredCars: [CarModel] = []
    var recentlyViewedCars: [CarModel] = []
    var recentCarIds: [String] = []
    
    var selectedImages: [PhotosPickerItem] = []
    var loadedImages: [UIImage] = []
    var profileImage: PhotosPickerItem?
    var loadedProfileImage: UIImage?
    
    var showAlert = false
    var alertMessage = ""
    
    let fuelPolicies = ["Full to Full", "Same to Same", "Empty to Empty"]
    let transmissionTypes = ["Manual", "Automatic", "Semi-Automatic"]
    var isButtonEnable: Bool = false
    var carErrors = [String: String]()
    
    var carState: FetchState = FetchState.good
    var uploadSuccess: Bool = false
    var toast: Toast? = nil
    var errorMessage: String? = nil
    var showError: Bool = false
}
