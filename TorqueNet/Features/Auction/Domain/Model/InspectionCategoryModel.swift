//
//  InspectionCategoryModel.swift
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


struct InspectionCategoryModel: Codable {
    let rating: Double
    let details: String
}
