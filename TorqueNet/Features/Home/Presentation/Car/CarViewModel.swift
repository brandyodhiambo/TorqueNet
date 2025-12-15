//
//  CarViewModel.swift
//  TorqueNet
//
//  Created by MAC on 08/12/2025.
//


import Foundation
import UIKit
import SwiftUI

@MainActor
class CarViewModel: ObservableObject {
    @Published var carUiState = CarUiState()
    
    func validateIfButtonIsEnabled(){
        var isFormValid = true
        
        if !carUiState.carErrors.values.allSatisfy({ $0.isEmpty }) || carUiState.carName.isEmpty || carUiState.carModel.isEmpty{
            isFormValid = false
        }
        
        carUiState.isButtonEnable = isFormValid
    }
    
    /**
            
     guard !car.carName.isEmpty else {
                throw ValidationError.emptyCarName
            }
            
            guard !car.carModel.isEmpty else {
                throw ValidationError.emptyCarModel
            }
            
            guard !car.ownerName.isEmpty else {
                throw ValidationError.emptyOwnerName
            }
            
            guard !carImages.isEmpty else {
                throw ValidationError.noCarImages
            }
            
            guard car.passengers > 0 else {
                throw ValidationError.invalidPassengers
            }
            
            guard car.doors > 0 else {
                throw ValidationError.invalidDoors
            }
     
     */
    
    func updateCarErrors(key: String, value: String) {
        carUiState.carErrors[key] = value
        validateIfButtonIsEnabled()
    }
    
    func updateCarName(value: String) {
        carUiState.carName = value
    }
}
