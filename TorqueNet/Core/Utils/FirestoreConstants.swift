//
//  FirestoreConstants.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 01/11/2025.
//
import Foundation
import Firebase

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("auctions")

}
