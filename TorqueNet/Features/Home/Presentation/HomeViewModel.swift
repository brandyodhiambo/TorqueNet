//
//  HomeViewModel.swift
//  TorqueNet
//
//  Created by MAC on 01/12/2025.
//
import Foundation
import UIKit

@MainActor
class HomeViewModel:ObservableObject{
    @Published  var searchText: String = ""
    @Published  var selectedBrandIndex = 0
    @Published  var selectedBrand:Brand? = nil
    @Published var isLocationAuthorized = false
    @Published var isShowRequestLocationAlert = false
    @Published var isShowTopBrandUrl = false
    @Published var locationName: String = "Loading..."
    @Published var currentUser: User?
    
    var brands: [Brand] = [
        Brand(image: "benz", title: "Mercedes-Benz",link: "https://www.mercedes-benz.com/en/"),
        Brand(image: "tesla", title: "Tesla",link: "https://www.tesla.com/"),
        Brand(image: "audi", title: "Audi",link: "https://www.audi.com/en/" ),
        Brand(image: "bmw", title: "BMW",link: "https://www.bmw.co.ke/en/index.html" ),
        Brand(image: "porsche", title: "Porsche",link: "https://www.porsche.com/international/" ),
        Brand(image: "toyota", title: "Toyota",link: "https://www.toyota.com/cars/")
    ]
    
    var featuredCars: [FeaturedCar] = [
        FeaturedCar(
            image: "car",
            title: "2023 Mercedes S-Class",
            price: 89000,
            location: "Nairobi, Kenya",
            mileage: "12,000 km",
            year: "2023",
            condition: "Excellent",
            isNew: true,
            rating: 4.9,
            reviewCount: 124
        ),
        FeaturedCar(
            image: "car",
            title: "BMW X5 M Competition",
            price: 76500,
            location: "Mombasa, Kenya",
            mileage: "25,000 km",
            year: "2022",
            condition: "Very Good",
            isNew: false,
            rating: 4.8,
            reviewCount: 89
        ),
        FeaturedCar(
            image: "car",
            title: "Tesla Model S Plaid",
            price: 95000,
            location: "Kisumu, Kenya",
            mileage: "8,000 km",
            year: "2023",
            condition: "Like New",
            isNew: true,
            rating: 4.9,
            reviewCount: 156
        )
    ]
    
    var quickActions: [QuickAction] = [
        QuickAction(icon: "car.2", title: "Compare", color: .blue),
        QuickAction(icon: "wallet.bifold", title: "Live Offers", color: .red),
        QuickAction(icon: "bell", title: "Alerts", color: .orange),
        QuickAction(icon: "calendar", title: "Schedule", color: .green)
    ]
    
}
