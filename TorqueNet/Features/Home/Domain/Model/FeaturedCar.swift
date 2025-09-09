//
//  FeaturedCar.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 09/09/2025.
//
import Foundation

struct FeaturedCar: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let price: Double
    let location: String
    let mileage: String
    let year: String
    let condition: String
    let isNew: Bool
    let rating: Double
    let reviewCount: Int
}
