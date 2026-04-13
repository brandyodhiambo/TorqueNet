//
//  ForgotPasswordViewModel.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation
import FirebaseAuth

@MainActor
class ForgotPasswordViewModel:ObservableObject {
    @Published var uiState = ForgotPasswordState()
    @Published var effect: ForgotEffect?
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func onAction(_intent:ForgotIntent){
        switch _intent {
        case .onEmailChanged(let email):
            uiState.email = email
            let error = ValidatorUtils.shared.validateEmail(email: uiState.email)
            updateForgotErrors(key: "email", value:  error)
        case .forgotPassword:
            Task{
                await handleForgotPassword()
            }
        }
        
    }
    
    func validateIfForgotPasswordIsEnabled(){
        var isFormValid = true
        
        if !uiState.forgotPasswordErrors.values.allSatisfy({ $0.isEmpty }) || uiState.email.isEmpty{
            isFormValid = false
        }
        
        uiState.isForgotPasswordEnable = isFormValid
    }
    
    func updateForgotErrors(key: String, value: String) {
        uiState.forgotPasswordErrors[key] = value
        validateIfForgotPasswordIsEnabled()
    }

    
    func updateDialogEntity(value: DialogEntity) {
        uiState.dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        uiState.isShowAlertDialog = value
    }
    
    
    private func handleForgotPassword() async {
        uiState.forgotPasswordState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await authUseCase.executeForgotPassword(email: uiState.email)

        switch result {
        case .success:
            uiState.forgotPasswordState = .good
            effect = .successDialog
            
        case .failure(let error):
            uiState.forgotPasswordState = .error(error.description)
            effect = .showError(error.description)
        }
    }
}
