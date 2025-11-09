//
//  SettingsUsecase.swift
//  TorqueNet
//
//  Created by MAC on 27/10/2025.
//
import UIKit

class SettingsUseCase{
    let settingsRepository:SettingsRepository
    
    init(settingsRepository:SettingsRepository){
        self.settingsRepository = settingsRepository
    }
    
    func executeFetchUser() async -> Result<User, FirebaseAuthError>{
        return await settingsRepository.fetchUser()
    }
    
    func executeUploadAndSaveProfileImage(_ image: UIImage) async -> Result<Void, FirebaseAuthError> {
           let uploadResult = await settingsRepository.uploadProfileImage(image)
           switch uploadResult {
           case .success(let imageUrl):
               let updateResult = await settingsRepository.updateUserProfileImage(imageUrl: imageUrl)
               return updateResult
           case .failure(let error):
               return .failure(error)
           }
       }
    
    func executeEditUser(email: String, phoneNumber: String,name:String,isSeller:Bool) async -> Result<Bool, FirebaseAuthError> {
        return await settingsRepository.editUser(email: email, phoneNumber: phoneNumber, name: name, isSeller: isSeller)
    }
}
