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
import CoreData

class SettingsRepositoryImpl: SettingsRepository {
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    static let shared = SettingsRepositoryImpl()
    let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
    
    func fetchUser(forceRefresh: Bool = false) async -> Result<User, FirebaseAuthError> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else {
                return .failure(.custom("User not found"))
            }
            let cachedUser = try getUserFromLocalStorage(uid: uid)
            
            if cachedUser == nil {
                let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
                guard snapshot.exists else { return .failure(.custom("User not found")) }
                let user = try snapshot.data(as: User.self)
                
                try cacheUserToLocalStorage(user: user)
                return .success(user)
            }
            try deleteUserById(uid: uid)
            
            let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
            guard snapshot.exists else { return .failure(.custom("User not found")) }
            let user = try snapshot.data(as: User.self)
            
            try cacheUserToLocalStorage(user: user)
            
            return .success(user)
            
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
            "uid":uid,
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
    
    private func cacheUserToLocalStorage(user: User) throws {
        guard let uid = user.uid else {
            throw NSError(domain: "CacheError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User uid is nil"])
        }
                
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            let userEntity: UserEntity
            if let existingEntity = results.first {
                userEntity = existingEntity
            } else {
                userEntity = UserEntity(context: context)
            }
            
            userEntity.toUserEntity(user)
            
            print("DEBUG: UserEntity values - uid: \(userEntity.uid ?? "nil"), name: \(userEntity.name ?? "nil"), email: \(userEntity.email ?? "nil")")
            
            if context.hasChanges {
                try context.save()
            } else {
                print("DEBUG: No changes to save")
            }
        } catch {
            print("DEBUG: Error caching user to local storage: \(error)")
            throw error
        }
    }
    
    private func getUserFromLocalStorage(uid: String) throws -> User? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        fetchRequest.fetchLimit = 1
        
        print("DEBUG: Fetching user from local storage with uid: \(uid)")
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let userEntity = results.first {
                print("DEBUG: Found cached user - uid: \(userEntity.uid ?? "nil"), name: \(userEntity.name ?? "nil")")
                let user = userEntity.toUser()
                print("DEBUG: Converted to User model - uid: \(user.uid ?? "nil")")
                return user
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    private func deleteUserById(uid: String) throws {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
                
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.isEmpty {
                return
            }
            results.forEach { entity in
                context.delete(entity)
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            throw error
        }
    }

}


