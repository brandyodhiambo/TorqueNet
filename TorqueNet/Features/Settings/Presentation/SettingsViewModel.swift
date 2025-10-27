//
//  SettingsViewModel.swift
//  TorqueNet
//
//  Created by MAC on 27/10/2025.
//
import Foundation

@MainActor
class SettingsViewModel:ObservableObject{
    @Published var showThemeSelector:Bool = false
    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var settingState:FetchState = FetchState.good
    
    let settingsUseCase:SettingsUseCase = SettingsUseCase(settingsRepository: SettingsRepositoryImpl.shared)
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func updateShowThemeSelectorDialog(value: Bool) {
        showThemeSelector = value
    }
    
    func updateDialogEntity(value: DialogEntity) {
        dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        isShowAlertDialog = value
    }
    
    func fetchUser(
        onSuccess: (User) -> Void,
        onFailure: (String) -> Void
    ) async {
        settingState = .isLoading
        
        var result:  Result<User, FirebaseAuthError>
        result = await settingsUseCase.executeFetchUser()
    
        switch result {
        case .success(let userDataResult):
            onSuccess(userDataResult)
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
            onFailure(error.description)
        }
    }
    
    
    func deleteAccount(
        onSuccess: (Bool) -> Void,
        onFailure: (String) -> Void
    ) async {
        settingState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await authUseCase.executeDeleteAccount()
    
        switch result {
        case .success(let userDataResult):
            onSuccess(userDataResult)
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
            onFailure(error.description)
        }
    }
    
    
    func logoutUser(
        onSuccess: (Bool) -> Void,
        onFailure: (String) -> Void
    ) async {
        settingState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await authUseCase.executeLogoutUser()
    
        switch result {
        case .success(let userDataResult):
            onSuccess(userDataResult)
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
            onFailure(error.description)
        }
    }
    
}
