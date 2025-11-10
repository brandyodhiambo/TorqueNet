//
//  SettingsViewModel.swift
//  TorqueNet
//
//  Created by MAC on 27/10/2025.
//
import Foundation
import UIKit

@MainActor
class SettingsViewModel:ObservableObject{
    @Published var showImagePicker = false
    @Published var showThemeSelector:Bool = false
    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var isChangePasswordEnable: Bool = false
    @Published var isEditProfile: Bool = false
    @Published var isSeller: Bool = false
    @Published var settingErrors = [String: String]()
    @Published var editErrors = [String: String]()
    @Published var settingState:FetchState = FetchState.good
    
    let settingsUseCase:SettingsUseCase = SettingsUseCase(settingsRepository: SettingsRepositoryImpl.shared)
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func validateIfChangePasswordIsEnabled(){
        var isFormValid = true
        
        if !settingErrors.values.allSatisfy({ $0.isEmpty }) || currentPassword.isEmpty || newPassword.isEmpty{
            isFormValid = false
        }
        isChangePasswordEnable = isFormValid
    }
    
    func validateIfEditProfileIsEnabled(){
        var isFormValid = true
        
        if !editErrors.values.allSatisfy({ $0.isEmpty }) || firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty{
            isFormValid = false
        }
        isEditProfile = isFormValid
    }
    
    func updateShowImagePickerDialog(value: Bool) {
        showImagePicker = value
    }
    
    func updateSettingErrors(key: String, value: String) {
        settingErrors[key] = value
        validateIfChangePasswordIsEnabled()
    }
    
    func updateEditErrors(key: String, value: String) {
        editErrors[key] = value
        validateIfEditProfileIsEnabled()
    }
    
    func updateCurrentPassword(value: String) {
        currentPassword = value
        let error = ValidatorUtils.shared.validatePassword(password: currentPassword)
        updateSettingErrors(key: "currentPassword", value:  error.first ?? "")
    }
    
    func updateNewPassword(value: String) {
        newPassword = value
        let error = ValidatorUtils.shared.validatePassword(password: currentPassword)
        updateSettingErrors(key: "newPassword", value:  error.first ?? "")
    }
    
    func updateFirstName(value: String) {
        firstName = value
        let error = ValidatorUtils.shared.validateName(name: firstName)
        updateEditErrors(key: "firstName", value: error)
    }
    
    func updateLastName(value: String) {
        lastName = value
        let error = ValidatorUtils.shared.validateName(name: lastName)
        updateEditErrors(key: "lastName", value: error)
    }
    
    func updatePhoneNumber(value: String) {
        phoneNumber = value
        let error = ValidatorUtils.shared.validatePhoneNumber(phoneNumber)
        updateEditErrors(key: "phoneNumber", value: error)
    }
    
    func updateEmail(value: String) {
        email = value
        let error = ValidatorUtils.shared.validateEmail(email: email)
        updateEditErrors(key: "email", value:  error)
    }
    
    func updateShowThemeSelectorDialog(value: Bool) {
        showThemeSelector = value
    }
    
    func updateDialogEntity(value: DialogEntity) {
        dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        isShowAlertDialog = value
    }
    
    func updateProfileImage(value: UIImage?) {
        profileImage = value
    }
    
    
    func uploadAndSaveProfileImage() async {
        settingState = .isLoading
        let result:  Result<Void, FirebaseAuthError>
        result = await settingsUseCase.executeUploadAndSaveProfileImage(profileImage!)
        switch result {
        case .success:
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
        }
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
            print("DEBUG: Error fetching user: \(error)")
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
    
    func changePassword(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        settingState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await authUseCase.executeChangePassword(currentPassword: currentPassword, newPassword: newPassword)
    
        switch result {
        case .success(let userDataResult):
            onSuccess()
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
            onFailure("Failed to change password: \(error.localizedDescription)")
        }
    }
    
    func editUser(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        settingState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await settingsUseCase.executeEditUser(email: email, phoneNumber: phoneNumber, name: firstName+" "+lastName, isSeller:isSeller)
    
        switch result {
        case .success(let userDataResult):
            onSuccess()
            settingState = .good
        case .failure(let error):
            settingState = .error(error.description)
            onFailure("Failed to edit user: \(error.localizedDescription)")
        }
    }
    
}
