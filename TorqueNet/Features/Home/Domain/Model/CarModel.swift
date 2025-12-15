//
//  CarModel.swift
//  TorqueNet
//
//  Created by MAC on 15/12/2025.
//

struct CarModel: Codable, Identifiable {
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
        case createdAt
    }
}
