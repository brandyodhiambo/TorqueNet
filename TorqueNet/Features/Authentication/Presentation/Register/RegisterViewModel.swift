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
    @Published var effect:RegisterEffect? = nil
    
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    
    func onAction(_intent:RegisterIntent){
        switch _intent {
        case .onFirstNameChange(let name):
            uiState.firstName = name
            let error = ValidatorUtils.shared.validateName(name: uiState.firstName)
            updateRegisterErrors(key: "firstName", value: error)
            
        case .onLastNameChange(let name):
            uiState.lastName = name
            let error = ValidatorUtils.shared.validateName(name: uiState.lastName)
            updateRegisterErrors(key: "lastName", value: error)
            
        case .onPhoneNumberChange(let phoneNumber):
            uiState.phoneNumber = phoneNumber
            let error = ValidatorUtils.shared.validatePhoneNumber(uiState.phoneNumber)
            updateRegisterErrors(key: "phoneNumber", value: error)
            
        case .onEmailChange(let email):
            uiState.email = email
            let error = ValidatorUtils.shared.validateEmail(email: uiState.email)
            updateRegisterErrors(key: "email", value:  error)
            
        case .onPasswordChange(let password):
            uiState.password = password
            let error = ValidatorUtils.shared.validatePassword(password: uiState.password)
            updateRegisterErrors(key: "password", value: error.first ?? "")
            
        case .onConfirmPasswordChange(let confirmPassword):
            uiState.confirmPassword = confirmPassword
            let error = ValidatorUtils.shared.validateConfirmPassword(password: uiState.password, confirmPassword: uiState.confirmPassword)
            updateRegisterErrors(key: "confirmPassword", value: error)
            
        case .register:
            Task{
               await handleRegister()
            }
        }
        
    }
    
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
    
    func updateDialogEntity(value: DialogEntity) {
        uiState.dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        uiState.isShowAlertDialog = value
    }
    
    private func handleRegister() async {
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
            uiState.registeState = .good
            effect = .successDialog
        case .failure(let error):
            uiState.registeState = .error(error.description)
            effect = .showError(error.description)
        }
    }
}
