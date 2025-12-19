//
//  FirestoreConstants.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 01/11/2025.
//
import Foundation
import Firebase
import FirebaseStorage

struct FirestoreConstants {
    static let UserCollection = Firestore.firestore().collection("users")
    static let AuctionsCollection = Firestore.firestore().collection("auctions")
    static let CarsCollection = Firestore.firestore().collection("cars")
    
    static let FirebaseStorage = Storage.storage()
    static let StorageRef = Storage.storage().reference()

}
