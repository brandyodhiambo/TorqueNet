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
import FirebaseStorage
import UIKit

class SettingsRepositoryImpl: SettingsRepository {
    static let shared = SettingsRepositoryImpl()
    
    func fetchUser() async -> Result<User, FirebaseAuthError> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else {
                return .failure(.custom("User not found"))
            }
            let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
            guard snapshot.exists else { return .failure(.custom("User not found")) }
            let user = try snapshot.data(as: User.self)
            return .success(user)
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
                return .failure(.userDisabled)
            case .userNotFound:
                return .failure(.userNotFound)
            default:
                print("DEBUG: fetchUser Error fetching user: \(error)")
                return .failure(.custom(error.localizedDescription))
            }
        } catch {
            return .failure(.custom(error.localizedDescription))
        }
    }
    
    func uploadProfileImage(_ image: UIImage) async -> Result<String, FirebaseAuthError> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else {
                return .failure(.custom("User not found"))
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                return .failure(.custom("Failed to compress image"))
            }
            
            let profileImageRef = FirestoreConstants.StorageRef.child("profile_images/\(uid).jpg")
            

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let _ = try await profileImageRef.putDataAsync(imageData, metadata: metadata)
            
            let downloadURL = try await profileImageRef.downloadURL()
            
            return .success(downloadURL.absoluteString)
            
        } catch {
            return .failure(.custom("Failed to upload image: \(error.localizedDescription)"))
        }
    }
    
    func updateUserProfileImage(imageUrl: String) async -> Result<Void, FirebaseAuthError> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else {
                return .failure(.custom("User not found"))
            }
            
            try await FirestoreConstants.UserCollection.document(uid).updateData([
                "profileImageUrl": imageUrl
            ])
            
            return .success(())
            
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
                return .failure(.userDisabled)
            case .userNotFound:
                return .failure(.userNotFound)
            default:
                return .failure(.custom(error.localizedDescription))
            }
        } catch {
            return .failure(.custom("Failed to update user profile: \(error.localizedDescription)"))
        }
    }
    
    func editUser(email: String, phoneNumber: String,name:String,isSeller:Bool) async -> Result<Bool, FirebaseAuthError>{
        guard let uid = Auth.auth().currentUser?.uid else {
            return .failure(.custom("User not found"))
        }
           

        let userData: [String: Any] = [
            "name": name,
            "email": email.lowercased(),
            "isSeller": isSeller,
            "phoneNumber": phoneNumber,
        ]
        
        do {
            try await FirestoreConstants.UserCollection.document(uid).updateData(userData)
            return .success(true)
        } catch let error as NSError {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
                return .failure(.userDisabled)
            case .userNotFound:
                return .failure(.userNotFound)
            default:
                return .failure(.custom(error.localizedDescription))
            }
        }
    }

}


