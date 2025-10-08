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
    @Published var dialogEntity = DialogEntity()
    @Published var isShowAlertDialog = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var isLoginEnable: Bool = false
    @Published var loginErrors = [String: String]()
    @Published var loginState: FetchState = FetchState.good
    
    let authUseCase: AuthUseCase = AuthUseCase(authRepository: AuthenticationRepositoryImpl.shared)
    
    func validateIfLoginIsEnabled(){
        var isFormValid = true
        
        if !loginErrors.values.allSatisfy({ $0.isEmpty }) || email.isEmpty || password.isEmpty{
            isFormValid = false
        }
        
        isLoginEnable = isFormValid
    }
    
    func updateLoginErrors(key: String, value: String) {
        loginErrors[key] = value
        validateIfLoginIsEnabled()
    }
    
    func updateEmail(value: String) {
        email = value
        let error = ValidatorUtils.shared.validateEmail(email: email)
        updateLoginErrors(key: "email", value:  error)
    }
    
    func updatePassword(value: String) {
        password = value
        let error = ValidatorUtils.shared.validatePassword(password: password)
        updateLoginErrors(key: "password", value: error.first ?? "")
    }
    
    func updateDialogEntity(value: DialogEntity) {
        dialogEntity = value
    }
    
    func updateIsShowAlertDialog(value: Bool) {
        isShowAlertDialog = value
    }
    
    func loginUser(
        onSuccess: () -> Void,
        onFailure: (String) -> Void
    ) async {
        loginState = .isLoading
        
        var result:  Result<AuthDataResult, FirebaseAuthError>
        result = await authUseCase.executeLoginUser(email: email, password: password)
    
        switch result {
        case .success(let authDataResult):
            onSuccess()
            loginState = .good
        case .failure(let error):
            loginState = .error(error.description)
            onFailure(error.description)
        }
        
    }
}
