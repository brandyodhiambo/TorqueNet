//
//  CarRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class CarRepositoryImpl: CarRepository {
    static let shared = CarRepositoryImpl()
    private let storageBasePath = "car_images"
    
    func uploadCar(_ car: CarModel, carImages: [UIImage], profileImage: UIImage?) async  -> Result<String, UploadError> {
        do {
            let carImageUrls = try await uploadImages(carImages, path: "cars/\(UUID().uuidString)")
            var profileImageUrl: String?
            if let profileImage = profileImage {
                profileImageUrl = try await uploadImage(profileImage, path: "profiles/\(UUID().uuidString)")
            }
            var carData = car
            let carDict: [String: Any] = [
                "id": FirestoreConstants.CarsCollection.document().documentID,
                "carName": carData.carName,
                "carModel": carData.carModel,
                "rating": carData.rating,
                "numberOfReviews": carData.numberOfReviews,
                "ownerName": carData.ownerName,
                "ownerRole": carData.ownerRole,
                "ownerProfileImageUrl": profileImageUrl ?? "",
                "carImageUrls": carImageUrls,
                "passengers": carData.passengers,
                "doors": carData.doors,
                "hasAirConditioner": carData.hasAirConditioner,
                "fuelPolicy": carData.fuelPolicy,
                "transmission": carData.transmission,
                "maxPower": carData.maxPower,
                "zeroToSixty": carData.zeroToSixty,
                "topSpeed": carData.topSpeed,
                "createdAt": Timestamp(date: carData.createdAt)
            ]
            let docRef = FirestoreConstants.CarsCollection.document()
            try docRef.setData(carDict)
            return .success(docRef.documentID)
        } catch {
            return .failure(.firestoreWriteFailed(error.localizedDescription))
        }
    }
    
    func uploadImages(_ images: [UIImage], path: String) async  -> Result<[String], UploadError> {
        var uploadedUrls: [String] = []

        for (index, image) in images.enumerated() {

            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                return .failure(.imageCompressionFailed)
            }

            let imageName = "\(path)/image_\(index).jpg"
            let storageRef = FirestoreConstants.StorageRef.child("\(storageBasePath)/\(imageName)")

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            do {
                _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
                let downloadUrl = try await storageRef.downloadURL()
                uploadedUrls.append(downloadUrl.absoluteString)

            } catch {
                if !uploadedUrls.isEmpty {
                    await deleteImagesOnFailure(urls: uploadedUrls)
                }
                return .failure(.imageUploadFailed(error.localizedDescription))
            }
        }

        return .success(uploadedUrls)
    }
    
    private func deleteImagesOnFailure(urls: [String]) async {
        for url in urls {
            if let ref = try? Storage.storage().reference(forURL: url) {
                try? await ref.delete()
            }
        }
    }
    
    func uploadImage(_ image: UIImage, path: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let storageRef = FirestoreConstants.StorageRef.child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        
        return downloadURL.absoluteString
        
    }
    
}
