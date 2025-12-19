//
//  AuctionUploadError.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum UploadError: LocalizedError {
    case imageCompressionFailed
    case imageUploadFailed(String)
    case firestoreWriteFailed(String)
    case firestoreUpdateFailed(String)
    case firestoreFetchFailed(String,String)
    case invalidData(String)
    case storageDeleteFailed(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .imageCompressionFailed:
            return "Failed to compress image. Please try again."
        case .imageUploadFailed(let message):
            return "Image upload failed: \(message)"
        case .firestoreWriteFailed(let message):
            return "Failed to save auction: \(message)"
        case .firestoreUpdateFailed(let message):
            return "Failed to update auction: \(message)"
        case .firestoreFetchFailed(let message, let name):
            return "Failed to fetch \(name): \(message)"
        case .storageDeleteFailed(let message):
            return "Failed to delete previous image: \(message)"
        case .invalidData(let message):
            return "Invalid data: \(message)"
        case .networkError:
            return "Network error. Please check your connection."
        }
    }
}
