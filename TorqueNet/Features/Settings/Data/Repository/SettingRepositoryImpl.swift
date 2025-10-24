//
//  SettingRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 24/10/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsRepositoryImpl: SettingsRepository {
    static let shared = SettingsRepositoryImpl()
    let db = Firestore.firestore()
    
    func fetchUser(by uid: String) async -> Result<User, FirebaseAuthError>{
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return .failure(.custom("User not found"))}
            let snapshot = try await db.collection("users").document(uid).getDocument()
            let user = try snapshot.data(as: User.self)
            if user != nil { return .success(user) }
            else { return .failure(.custom("user not found")) }
        }
        catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
                return .failure(.userDisabled)
            case .userNotFound:
                return .failure(.userNotFound)
            default:
                return .failure(.custom(error.localizedDescription))
            }
        }
        catch {
            return .failure(.custom(error.localizedDescription))
        }
    }
    
}
