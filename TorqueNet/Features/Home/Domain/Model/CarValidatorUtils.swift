//
//  ValidationError.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

import Foundation
import UIKit

class CarValidatorUtils {
    static let shared = CarValidatorUtils()
    
    func validateCarName(name: String) -> String {
        if name.isEmpty {
            return "Car name is required"
        }
        if name.count < 3 {
            return "Car name must be at least 3 characters"
        }
        return ""
    }
    
    func validateCarModel(model: String) -> String {
        if model.isEmpty {
            return "Car model is required"
        }
        if model.count < 2 {
            return "Car model must be at least 2 characters"
        }
        return ""
    }
    
    func validateNumberOfReviews(reviews: String) -> String {
        if reviews.isEmpty {
            return ""
        }
        if Int(reviews) == nil {
            return "Please enter a valid number"
        }
        if let count = Int(reviews), count < 0 {
            return "Reviews cannot be negative"
        }
        return ""
    }
    
    func validateOwnerName(name: String) -> String {
        if name.isEmpty {
            return "Owner name is required"
        }
        if name.count < 2 {
            return "Owner name must be at least 2 characters"
        }
        return ""
    }
    
    func validateOwnerRole(role: String) -> String {
        if role.isEmpty {
            return ""
        }
        if role.count < 2 {
            return "Role must be at least 2 characters"
        }
        return ""
    }
    
    func validatePassengers(passengers: String) -> String {
        if passengers.isEmpty {
            return "Number of passengers is required"
        }
        guard let count = Int(passengers) else {
            return "Please enter a valid number"
        }
        if count <= 0 {
            return "Passengers must be greater than 0"
        }
        if count > 20 {
            return "Passengers cannot exceed 20"
        }
        return ""
    }
    
    func validateDoors(doors: String) -> String {
        if doors.isEmpty {
            return "Number of doors is required"
        }
        guard let count = Int(doors) else {
            return "Please enter a valid number"
        }
        if count <= 0 {
            return "Doors must be greater than 0"
        }
        if count > 10 {
            return "Doors cannot exceed 10"
        }
        return ""
    }
    
    func validateMaxPower(power: String) -> String {
        if power.isEmpty {
            return "Max power is required"
        }
        if power.count < 2 {
            return "Please enter valid power specification"
        }
        return ""
    }
    
    func validateZeroToSixty(time: String) -> String {
        if time.isEmpty {
            return "0-60 time is required"
        }
        if time.count < 2 {
            return "Please enter valid time specification"
        }
        return ""
    }
    
    func validateTopSpeed(speed: String) -> String {
        if speed.isEmpty {
            return "Top speed is required"
        }
        if speed.count < 2 {
            return "Please enter valid speed specification"
        }
        return ""
    }
    
    func validateCarImages(images: [UIImage]) -> String {
        if images.isEmpty {
            return "Please add at least one car image"
        }
        return ""
    }
}
