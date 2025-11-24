//
//  User.swift
//  TorqueNet
//
//  Created by MAC on 24/10/2025.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var uid: String?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var profileImageUrl: String?
    var isSeller: Bool?
    var cars:Int
    var rides:Int
    @ServerTimestamp var createdAt: Date?
    
    var initials: String {
        let components = name?.split(separator: " ")
        let initials = components?.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials?.joined().uppercased() ?? ""
    }
    
    var firstName: String? {
        name?.components(separatedBy: " ").first ?? name
    }
}

extension User {
    static let MOCK_USER = User(
        uid: "mock-uid-123",
        name: "Mock User",
        email: "mockuser@gmail.com",
        phoneNumber: "0712345678",
        profileImageUrl: "https://example.com/mock_profile.jpg",
        isSeller: false,
        cars: 26,
        rides:1,
        createdAt: Date()
    )
}

