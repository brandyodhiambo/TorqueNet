//
//  InspectionReport.swift
//  TorqueNet
//
//  Created by MAC on 18/11/2025.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine


struct InspectionReportModel: Codable {
    let exterior: InspectionCategoryModel
    let interior: InspectionCategoryModel
    let engine: InspectionCategoryModel
    let transmission: InspectionCategoryModel
    let electronics: InspectionCategoryModel
    let overallRating: Double
    
    enum CodingKeys: String, CodingKey {
        case exterior
        case interior
        case engine
        case transmission
        case electronics
        case overallRating = "overall_rating"
    }
}
