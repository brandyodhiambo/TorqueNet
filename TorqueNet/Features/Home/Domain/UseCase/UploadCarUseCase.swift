//
//  UploadCarUsecase.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

import UIKit

class UploadCarUseCase {
    private let repository: CarRepository
    
    init(repository: CarRepository) {
        self.repository = repository
    }
    
    func execute(car: CarModel, carImages: [UIImage], profileImage: UIImage?) async -> Result<String, UploadError> {
        return await repository.uploadCar(car, carImages: carImages, profileImage: profileImage)
    }
}
