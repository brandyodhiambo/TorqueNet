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
    @Published var effect: LoginEffect?
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    
    func onAction(_ intent: LoginIntent) {
        switch intent {
        case .onEmailChange(let value):
            uiState.email = value
            let error = ValidatorUtils.shared.validateEmail(email: value)
            uiState.loginErrors["email"] = error
            validateIfLoginIsEnabled()
            
        case .onPasswordChange(let value):
            uiState.password = value
            let error = ValidatorUtils.shared.validatePassword(password: value)
            uiState.loginErrors["password"] = error.first ?? ""
            validateIfLoginIsEnabled()
            
        case .onRememberMe(let value):
            uiState.rememberMe = value
            
        case .login:
            Task {
                await handleLogin()
            }
        }
    }
    
    
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
    
    func updateDialogEntity(value: DialogEntity) {
        uiState.dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        uiState.isShowAlertDialog = value
    }
    
    private func handleLogin() async {
        uiState.loginState = .isLoading
        
        let result = await authUseCase.executeLoginUser(
            email: uiState.email,
            password: uiState.password
        )

        switch result {
        case .success:
            uiState.loginState = .good
            effect = .navigateToDashboard
            
        case .failure(let error):
            uiState.loginState = .error(error.description)
            effect = .showError(error.description)
        }
    }
}
