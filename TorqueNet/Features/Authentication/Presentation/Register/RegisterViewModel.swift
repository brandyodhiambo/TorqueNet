//
//  RegisterViewModel.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 07/10/2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase



@MainActor
class RegisterViewModel: ObservableObject {
    @Published var uiState = RegisterState()
    
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func validateIfRegisterIsEnabled(){
        var isFormValid = true
        
        if !uiState.registerErrors.values.allSatisfy({ $0.isEmpty }) || uiState.email.isEmpty || uiState.password.isEmpty || uiState.firstName.isEmpty || uiState.lastName.isEmpty || uiState.phoneNumber.isEmpty || uiState.confirmPassword.isEmpty{
            isFormValid = false
        }
        
        uiState.isRegisterEnabled = isFormValid
    }
    
    func updateRegisterErrors(key: String, value: String) {
        uiState.registerErrors[key] = value
        validateIfRegisterIsEnabled()
    }
    
    func updateFirstName(value: String) {
        uiState.firstName = value
        let error = ValidatorUtils.shared.validateName(name: uiState.firstName)
        updateRegisterErrors(key: "firstName", value: error)
    }
    
    func updateLastName(value: String) {
        uiState.lastName = value
        let error = ValidatorUtils.shared.validateName(name: uiState.lastName)
        updateRegisterErrors(key: "lastName", value: error)
    }
    
    func updatePhoneNumber(value: String) {
        uiState.phoneNumber = value
        let error = ValidatorUtils.shared.validatePhoneNumber(uiState.phoneNumber)
        updateRegisterErrors(key: "phoneNumber", value: error)
    }
    
    func updateEmail(value: String) {
        uiState.email = value
        let error = ValidatorUtils.shared.validateEmail(email: uiState.email)
        updateRegisterErrors(key: "email", value:  error)
    }
    
    func updatePassword(value: String) {
        uiState.password = value
        let error = ValidatorUtils.shared.validatePassword(password: uiState.password)
        updateRegisterErrors(key: "password", value: error.first ?? "")
    }
    
    func updateConfirmPassword(value: String) {
        uiState.confirmPassword = value
        let error = ValidatorUtils.shared.validateConfirmPassword(password: uiState.password, confirmPassword: uiState.confirmPassword)
        updateRegisterErrors(key: "confirmPassword", value: error)
    }
    
    func updateDialogEntity(value: DialogEntity) {
        uiState.dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        uiState.isShowAlertDialog = value
    }
    
    func registerUser(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        uiState.registeState = .isLoading
        
        var result:  Result<AuthDataResult, FirebaseAuthError>
        result = await authUseCase.executeRegiserUser(
            firstName: uiState.firstName,
            lastName: uiState.lastName,
            email: uiState.email,
            password: uiState.password,
            phoneNumber: uiState.phoneNumber
        )
        switch result {
        case .success(let authDataResult):
            print("DEBUG: Regiter success. User OpenId: \(authDataResult.user.uid)")
            onSuccess()
            uiState.registeState = .good
        case .failure(let error):
            uiState.registeState = .error(error.description)
            onFailure(error.description)
        }
        
    }
}
