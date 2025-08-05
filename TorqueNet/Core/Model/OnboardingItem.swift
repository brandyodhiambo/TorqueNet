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
            .init(image: "🤝", title: "Join the crew", content: "Handshake. Two hands performing a handshake gesture, indicating a cordial greeting between friends or associates. "),
            .init(image: "❤️", title: "Support the crew", content: "A classic red love heart emoji. The red heart ideograph is traditionally used for expressions of love and romance across many cultures."),
            .init(image: "🥳", title: "Celebrate the crew", content: "Celebrate the crew and congratulation for joining the crew"),
            .init(image: "👨‍🎓", title: "Eduction", content: "Eduction is the key to success and prosperity and so are we."),
        ]
    }
}
