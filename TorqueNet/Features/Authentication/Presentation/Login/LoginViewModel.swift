//
//  LoginViewModel.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//
import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel:ObservableObject {
    @Published var uiState = LoginState()
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    
    func validateIfLoginIsEnabled(){
        var isFormValid = true
        
        if !uiState.loginErrors.values.allSatisfy({ $0.isEmpty }) || uiState.email.isEmpty || uiState.password.isEmpty{
            isFormValid = false
        }
        
        uiState.isLoginEnable = isFormValid
    }
    
    func updateLoginErrors(key: String, value: String) {
        uiState.loginErrors[key] = value
        validateIfLoginIsEnabled()
    }
    
    func updateEmail(value: String) {
        uiState.email = value
        let error = ValidatorUtils.shared.validateEmail(email: uiState.email)
        updateLoginErrors(key: "email", value:  error)
    }
    
    func updatePassword(value: String) {
        uiState.password = value
        let error = ValidatorUtils.shared.validatePassword(password: uiState.password)
        updateLoginErrors(key: "password", value: error.first ?? "")
    }
    
    func updateDialogEntity(value: DialogEntity) {
        uiState.dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        uiState.isShowAlertDialog = value
    }
    
    func loginUser(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        uiState.loginState = .isLoading
        
        var result:  Result<AuthDataResult, FirebaseAuthError>
        result = await authUseCase.executeLoginUser(email: uiState.email, password: uiState.password)
    
        switch result {
        case .success(let authDataResult):
            onSuccess()
            uiState.loginState = .good
        case .failure(let error):
            uiState.loginState = .error(error.description)
            onFailure(error.description)
        }
        
    }
}
