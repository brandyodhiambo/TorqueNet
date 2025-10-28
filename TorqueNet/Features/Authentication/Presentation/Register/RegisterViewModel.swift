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
    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isRegisterEnabled: Bool = false
    @Published var registerErrors = [String: String]()
    @Published var registeState: FetchState = FetchState.good
    
    
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func validateIfRegisterIsEnabled(){
        var isFormValid = true
        
        if !registerErrors.values.allSatisfy({ $0.isEmpty }) || email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty || confirmPassword.isEmpty{
            isFormValid = false
        }
        
        isRegisterEnabled = isFormValid
    }
    
    func updateRegisterErrors(key: String, value: String) {
        registerErrors[key] = value
        validateIfRegisterIsEnabled()
    }
    
    func updateFirstName(value: String) {
        firstName = value
        let error = ValidatorUtils.shared.validateName(name: firstName)
        updateRegisterErrors(key: "firstName", value: error)
    }
    
    func updateLastName(value: String) {
        lastName = value
        let error = ValidatorUtils.shared.validateName(name: lastName)
        updateRegisterErrors(key: "lastName", value: error)
    }
    
    func updatePhoneNumber(value: String) {
        phoneNumber = value
        let error = ValidatorUtils.shared.validatePhoneNumber(phoneNumber)
        updateRegisterErrors(key: "phoneNumber", value: error)
    }
    
    func updateEmail(value: String) {
        email = value
        let error = ValidatorUtils.shared.validateEmail(email: email)
        updateRegisterErrors(key: "email", value:  error)
    }
    
    func updatePassword(value: String) {
        password = value
        let error = ValidatorUtils.shared.validatePassword(password: password)
        updateRegisterErrors(key: "password", value: error.first ?? "")
    }
    
    func updateConfirmPassword(value: String) {
        confirmPassword = value
        let error = ValidatorUtils.shared.validateConfirmPassword(password: password, confirmPassword: confirmPassword)
        updateRegisterErrors(key: "confirmPassword", value: error)
    }
    
    func updateDialogEntity(value: DialogEntity) {
        dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        isShowAlertDialog = value
    }
    
    func registerUser(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        registeState = .isLoading
        
        var result:  Result<AuthDataResult, FirebaseAuthError>
        result = await authUseCase.executeRegiserUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            phoneNumber: phoneNumber
        )
        switch result {
        case .success(let authDataResult):
            print("DEBUG: Regiter success. User OpenId: \(authDataResult.user.uid)")
            onSuccess()
            registeState = .good
        case .failure(let error):
            registeState = .error(error.description)
            onFailure(error.description)
        }
        
    }
}
