//
//  ValidationError.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

import Foundation

enum ValidationError: LocalizedError {
    case emptyCarName
    case emptyCarModel
    case emptyOwnerName
    case noCarImages
    case invalidPassengers
    case invalidDoors
    
    var errorDescription: String? {
        switch self {
        case .emptyCarName:
            return "Car name is required"
        case .emptyCarModel:
            return "Car model is required"
        case .emptyOwnerName:
            return "Owner name is required"
        case .noCarImages:
            return "Please add at least one car image"
        case .invalidPassengers:
            return "Number of passengers must be greater than 0"
        case .invalidDoors:
            return "Number of doors must be greater than 0"
        }
    }
}
