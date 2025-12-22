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
    
    func uploadCar(
        _ car: CarModel,
        carImages: [UIImage],
        profileImage: UIImage?
    ) async -> Result<String, UploadError> {

        let imageUploadResult = await uploadImages(
            carImages,
            path: "cars/\(UUID().uuidString)"
        )

        let carImageUrls: [String]
        switch imageUploadResult {
        case .success(let urls):
            carImageUrls = urls
        case .failure(let error):
            return .failure(error)
        }

        var profileImageUrl: String?
        if let profileImage = profileImage {
            let profileResult = await uploadImage(
                profileImage,
                path: "profiles/\(UUID().uuidString)"
            )

            switch profileResult {
            case .success(let url):
                profileImageUrl = url
            case .failure(let error):
                return .failure(error)
            }
        }
        

        let docRef = FirestoreConstants.CarsCollection.document()

        let carDict: [String: Any] = [
            "id": docRef.documentID,
            "carName": car.carName,
            "carModel": car.carModel,
            "rating": car.rating,
            "numberOfReviews": car.numberOfReviews,
            "ownerName": car.ownerName,
            "ownerRole": car.ownerRole,
            "ownerProfileImageUrl": profileImageUrl ?? "",
            "carImageUrls": carImageUrls,
            "passengers": car.passengers,
            "doors": car.doors,
            "hasAirConditioner": car.hasAirConditioner,
            "fuelPolicy": car.fuelPolicy,
            "transmission": car.transmission,
            "maxPower": car.maxPower,
            "zeroToSixty": car.zeroToSixty,
            "topSpeed": car.topSpeed,
            "carCondition": car.carCondition,
            "isNewCar": car.isNewCar,
            "createdAt": Timestamp(date: car.createdAt)
        ]

        do {
            try await docRef.setData(carDict)
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
    
    func uploadImage(_ image: UIImage, path: String) async -> Result<String, UploadError> {
        var profileImageUrl: String = ""
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return .failure(.imageCompressionFailed)
        }
        
        let storageRef = FirestoreConstants.StorageRef.child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do{
            _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            profileImageUrl = downloadURL.absoluteString
        } catch {
            return .failure(.imageUploadFailed(error.localizedDescription))
        }
        return .success(profileImageUrl)
        
    }
    
    func fetchCars() async -> Result<[CarModel], UploadError> {
        do {
            let snapshot = try await FirestoreConstants.CarsCollection
                .order(by: "createdAt", descending: true)
                .getDocuments()


            let cars: [CarModel] = snapshot.documents.compactMap { document in
                try? document.data(as: CarModel.self)
            }

            return .success(cars)

        } catch {
            return .failure(
                .firestoreFetchFailed(error.localizedDescription, "cars")
            )
        }
    }

    
}
