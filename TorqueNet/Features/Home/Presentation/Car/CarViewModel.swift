//
//  CarViewModel.swift
//  TorqueNet
//
//  Created by MAC on 08/12/2025.
//


import Foundation
import UIKit
import SwiftUI
import _PhotosUI_SwiftUI

@MainActor
class CarViewModel: ObservableObject {
    @Published var carUiState = CarUiState()
    let carUseCase: UploadCarUseCase = UploadCarUseCase(repository: CarRepositoryImpl.shared)
    
    func validateIfButtonIsEnabled() {
        var isFormValid = true
        
        if !carUiState.carErrors.values.allSatisfy({ $0.isEmpty }) ||
            carUiState.carName.isEmpty ||
            carUiState.carModel.isEmpty ||
            carUiState.ownerName.isEmpty ||
            carUiState.passengers.isEmpty ||
            carUiState.doors.isEmpty ||
            carUiState.maxPower.isEmpty ||
            carUiState.zeroToSixty.isEmpty ||
            carUiState.topSpeed.isEmpty ||
            carUiState.loadedImages.isEmpty {
            isFormValid = false
        }
        
        carUiState.isButtonEnable = isFormValid
    }
    func updateCarCondition(value: String) {
        carUiState.carCondition = value
    }
    
    func updateCarErrors(key: String, value: String) {
        carUiState.carErrors[key] = value
        validateIfButtonIsEnabled()
    }
    func updateCarName(value: String) {
        carUiState.carName = value
        let error = CarValidatorUtils.shared.validateCarName(name: carUiState.carName)
        updateCarErrors(key: "carName", value: error)
    }
    
    func updateCarModel(value: String) {
        carUiState.carModel = value
        let error = CarValidatorUtils.shared.validateCarModel(model: carUiState.carModel)
        updateCarErrors(key: "carModel", value: error)
    }
    
    func updateNumberOfReviews(value: String) {
        carUiState.numberOfReviews = value
        let error = CarValidatorUtils.shared.validateNumberOfReviews(reviews: carUiState.numberOfReviews)
        updateCarErrors(key: "numberOfReviews", value: error)
    }
    
    func updateOwnerName(value: String) {
        carUiState.ownerName = value
        let error = CarValidatorUtils.shared.validateOwnerName(name: carUiState.ownerName)
        updateCarErrors(key: "ownerName", value: error)
    }
    
    func updateOwnerRole(value: String) {
        carUiState.ownerRole = value
        let error = CarValidatorUtils.shared.validateOwnerRole(role: carUiState.ownerRole)
        updateCarErrors(key: "ownerRole", value: error)
    }
    
    func updatePassengers(value: String) {
        carUiState.passengers = value
        let error = CarValidatorUtils.shared.validatePassengers(passengers: carUiState.passengers)
        updateCarErrors(key: "passengers", value: error)
    }
    
    func updateDoors(value: String) {
        carUiState.doors = value
        let error = CarValidatorUtils.shared.validateDoors(doors: carUiState.doors)
        updateCarErrors(key: "doors", value: error)
    }
    
    func updateMaxPower(value: String) {
        carUiState.maxPower = value
        let error = CarValidatorUtils.shared.validateMaxPower(power: carUiState.maxPower)
        updateCarErrors(key: "maxPower", value: error)
    }
    
    func updateZeroToSixty(value: String) {
        carUiState.zeroToSixty = value
        let error = CarValidatorUtils.shared.validateZeroToSixty(time: carUiState.zeroToSixty)
        updateCarErrors(key: "zeroToSixty", value: error)
    }
    
    func updateTopSpeed(value: String) {
        carUiState.topSpeed = value
        let error = CarValidatorUtils.shared.validateTopSpeed(speed: carUiState.topSpeed)
        updateCarErrors(key: "topSpeed", value: error)
    }
    
    func updateRating(value: Double) {
        carUiState.rating = value
    }
    
    func updateHasAirConditioner(value: Bool) {
        carUiState.hasAirConditioner = value
    }
    
    func updateFuelPolicy(value: String) {
        carUiState.fuelPolicy = value
    }
    
    func updateTransmission(value: String) {
        carUiState.transmission = value
    }
    
    
    func loadImages(from items: [PhotosPickerItem]) {
        carUiState.loadedImages.removeAll()
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.carUiState.loadedImages.append(image)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }
    
    func loadProfileImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.carUiState.loadedProfileImage = image
                    }
                }
            case .failure(let error):
                print("Error loading profile image: \(error)")
            }
        }
    }
    
    func uploadCar(
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        carUiState.carState = .isLoading
        let car = CarModel(
            carName: carUiState.carName,
            carModel: carUiState.carModel,
            rating: carUiState.rating,
            numberOfReviews: Int(carUiState.numberOfReviews) ?? 0,
            ownerName: carUiState.ownerName,
            ownerRole: carUiState.ownerRole,
            ownerProfileImageUrl: nil,
            carImageUrls: [],
            passengers: Int(carUiState.passengers) ?? 0,
            doors: Int(carUiState.doors) ?? 0,
            hasAirConditioner: carUiState.hasAirConditioner,
            fuelPolicy: carUiState.fuelPolicy,
            transmission: carUiState.transmission,
            maxPower: carUiState.maxPower,
            zeroToSixty: carUiState.zeroToSixty,
            topSpeed: carUiState.topSpeed,
            carCondition: carUiState.carCondition,
            isNewCar: carUiState.isNewCar,
            createdAt: Date()
        )
        
        let result = await carUseCase.execute(
            car: car,
            carImages: carUiState.loadedImages,
            profileImage: carUiState.loadedProfileImage
        )
        
        switch result {
        case .success(let id):
            carUiState.carState = .good
            carUiState.uploadSuccess = true
            carUiState.uploadSuccess = true
            carUiState.showError = false
            carUiState.errorMessage = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetForm()
            }
            onSuccess()
            
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            carUiState.carState = .error(message)
            carUiState.errorMessage = message
            carUiState.showError = true
            onFailure(message)
            
        }
    }
    
    func resetForm() {
        carUiState = CarUiState()
    }
    
    func fetchCars(
        onSuccess:() -> Void,
        onFailure: (String) -> Void
    ) async {
        let result = await carUseCase.fetchCars()
        switch result {
        case .success(let cars):
            self.carUiState.fetchedCars = cars
            
            load()
            self.carUiState.recentlyViewedCars = carUiState.recentCarIds.compactMap{ id in
                self.carUiState.fetchedCars.first{
                    $0.id == id
                }
            }
            onSuccess()
        case .failure(let error):
            let message = error.errorDescription?.description ?? "An unexpected error occurred."
            carUiState.carState = .error(message)
            carUiState.errorMessage = message
            carUiState.showError = true
            onFailure(message)
        }
    }
    
    
    func load() {
        carUiState.recentCarIds = carUseCase.getRecentlyViewedIds()
    }
    
    func onCarViewed(carId: String) {
        carUseCase.track(carId: carId)
        load()
    }
    
    func clear() {
        carUseCase.clear()
        load()
    }
    
    
}
