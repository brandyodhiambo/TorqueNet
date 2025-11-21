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

    
    func fetchUser(forceRefresh: Bool) async -> Result<User, FirebaseAuthError> {
        do {
            guard let uid = Auth.auth().currentUser?.uid else {
                return .failure(.custom("User not found"))
            }
            
//            if !forceRefresh,let cachedUser = try getUserFromLocalStorage() {
//                print("DEBUG: Returning cached user")
//                return .success(cachedUser)
//            }
//            
            let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
            guard snapshot.exists else { return .failure(.custom("User not found")) }
            let user = try snapshot.data(as: User.self)
            
//            try deleteUserById(uid: uid)
//            try cacheUserToLocalStorage(user:user)
            
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
    
    func cacheUserToLocalStorage(user:User) throws{
        do {
            let results = try context.fetch(fetchRequest)
        
            let userEntity: UserEntity
            if let existingEntity = results.first {
                userEntity = existingEntity
                print("DEBUG: Updating existing cached user")
            } else {
                userEntity = UserEntity(context: context)
                print("DEBUG: Caching new user")
            }
            userEntity.toUserEntity(user)
            
            // Save context
            try context.save()
            print("DEBUG: User cached successfully")
        } catch {
            print("DEBUG: Error caching user: \(error)")
        }
    }
    
    func getUserFromLocalStorage() throws -> User? {
        let result = try context.fetch(fetchRequest)
        return result.first?.toUser()
    }
    
    func deleteUserById(uid: String) throws {
        fetchRequest.predicate = NSPredicate(format: "id == %@", uid)
        if let entity = try context.fetch(fetchRequest).first {
            context.delete(entity)
            try context.save()
        }
    }

}


