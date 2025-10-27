//
//  SettingsUsecase.swift
//  TorqueNet
//
//  Created by MAC on 27/10/2025.
//

class SettingsUseCase{
    let settingsRepository:SettingsRepository
    
    init(settingsRepository:SettingsRepository){
        self.settingsRepository = settingsRepository
    }
    
    func executeFetchUser() async -> Result<User, FirebaseAuthError>{
        return await settingsRepository.fetchUser()
    }
    
}
