//
//  BidRecordModel.swift
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


struct BidRecordModel: Codable {
    let bidder: String
    let amount: Double
    let timestamp: Timestamp
    let isHighest: Bool
    
    enum CodingKeys: String, CodingKey {
        case bidder
        case amount
        case timestamp
        case isHighest = "is_highest"
    }
}
