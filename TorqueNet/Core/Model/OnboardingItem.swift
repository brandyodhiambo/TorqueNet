//
//  OnboardingItem.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let content: String
}

extension OnboardingItem: Equatable {}


final class OnboardingManager: ObservableObject {
    @Published private(set) var items: [OnboardingItem] = []
    
    func load() {
        items = [
            .init(image: "car", title: "Car Binding", content: "Get the opportunity to bind your car with TorqueNet Easily connect your vehicle to your profile for better management"),
            .init(image: "carAuction", title: "Auction Management", content: "Auction car is the best way to get the car at the lowest price and manage your auctions at all times"),
            .init(image: "carKey2", title: "Car Key", content: "Obtain your car key and get ready to hit the road,Start driving with ease and confidence in your new ride Everything you need is now at your fingertips"),
        ]
    }
}
