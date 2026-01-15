//
//  CarModel.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

import Foundation

struct CarModel: Codable, Identifiable,Equatable,Hashable {
    var id: String?
    let carName: String
    let carModel: String
    let rating: Double
    let numberOfReviews: Int
    let ownerName: String
    let ownerRole: String
    let ownerProfileImageUrl: String?
    let carImageUrls: [String]
    let passengers: Int
    let doors: Int
    let hasAirConditioner: Bool
    let fuelPolicy: String
    let transmission: String
    let maxPower: String
    let zeroToSixty: String
    let topSpeed: String
    let carCondition: String
    let isNewCar: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case carName
        case carModel
        case rating
        case numberOfReviews
        case ownerName
        case ownerRole
        case ownerProfileImageUrl
        case carImageUrls
        case passengers
        case doors
        case hasAirConditioner
        case fuelPolicy
        case transmission
        case maxPower
        case zeroToSixty
        case topSpeed
        case carCondition
        case isNewCar
        case createdAt
    }
}

extension CarModel{
    static let preview: CarModel = CarModel(
        id: "001",
        carName: "Toyota Camry",
        carModel: "SE 2022",
        rating: 4.6,
        numberOfReviews: 128,
        ownerName: "Alex Johnson",
        ownerRole: "Host",
        ownerProfileImageUrl: "https://example.com/profiles/alex.jpg",
        carImageUrls: [
            "https://example.com/cars/camry_front.jpg",
            "https://example.com/cars/camry_side.jpg",
            "https://example.com/cars/camry_interior.jpg"
        ],
        passengers: 5,
        doors: 4,
        hasAirConditioner: true,
        fuelPolicy: "Full to Full",
        transmission: "Automatic",
        maxPower: "203 hp",
        zeroToSixty: "7.6s",
        topSpeed: "135 mph",
        carCondition: "Excellent",
        isNewCar: false,
        createdAt: Date(timeIntervalSince1970: 1_700_000_000)
    )
    
}
