//
//  CarRepository.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//
import Foundation
import UIKit

protocol CarRepository {
    func uploadCar(_ car: CarModel, carImages: [UIImage], profileImage: UIImage?) async  -> Result<String, UploadError>
    func uploadImages(_ images: [UIImage], path: String) async  -> Result<[String], UploadError>
    func fetchCars() async  -> Result<[CarModel], UploadError>
    
    //Recently Viewed Car Ids
    func getIds() -> [String]
    func setId(id: String)
    func clearIds()
}
