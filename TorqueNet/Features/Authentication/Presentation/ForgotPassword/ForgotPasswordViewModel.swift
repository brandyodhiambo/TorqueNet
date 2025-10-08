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
    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var email: String = ""
    @Published var isForgotPasswordEnable: Bool = false
    @Published var forgotPasswordErrors = [String: String]()
    @Published var forgotPasswordState: FetchState = FetchState.good
    
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func validateIfForgotPasswordIsEnabled(){
        var isFormValid = true
        
        if !forgotPasswordErrors.values.allSatisfy({ $0.isEmpty }) || email.isEmpty{
            isFormValid = false
        }
        
        isForgotPasswordEnable = isFormValid
    }
    
    func updateForgotErrors(key: String, value: String) {
        forgotPasswordErrors[key] = value
        validateIfForgotPasswordIsEnabled()
    }
    
    func updateEmail(value: String) {
        email = value
        let error = ValidatorUtils.shared.validateEmail(email: email)
        updateForgotErrors(key: "email", value:  error)
    }

    
    func updateDialogEntity(value: DialogEntity) {
        dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        isShowAlertDialog = value
    }
    
    func forgotPassword(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        forgotPasswordState = .isLoading
        
        var result:  Result<Bool, FirebaseAuthError>
        result = await authUseCase.executeForgotPassword(email: email)
    
        switch result {
        case .success(let authDataResult):
            onSuccess()
            forgotPasswordState = .good
        case .failure(let error):
            forgotPasswordState = .error(error.description)
            onFailure(error.description)
        }
        
    }
}
