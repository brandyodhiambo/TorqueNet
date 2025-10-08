//
//  AuthUseCase.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation
import FirebaseAuth

class AuthUseCase{
    let authRepository: AuthenticationRepository
    
    init(authRepository: AuthenticationRepository) {
        self.authRepository = authRepository
    }
    
    func executeRegiserUser(firstName: String,lastName:String,email: String, password: String) async ->  Result<AuthDataResult, FirebaseAuthError>{
        return await authRepository.signUpUser(name: firstName+" "+lastName, email: email, password: password)
         
    }
    
    func executeLoginUser(email: String, password: String) async ->  Result<AuthDataResult, FirebaseAuthError>{
        return await authRepository.signInUser(email: email, password: password)
    }
    
    func executeGoogleSignIn() async ->  Result<AuthDataResult, FirebaseAuthError>{
        return await authRepository.googleSignIn()
    }
    
    func executeForgotPassword(email: String) async ->  Result<Bool,FirebaseAuthError>{
        return await authRepository.forgotPassword(email: email)
    }
    
    func executeLogoutUser() async ->  Result<Bool,FirebaseAuthError>{
        return await authRepository.logoutUser()
    }
    
    func executeDeleteAccount() async ->  Result<Bool,FirebaseAuthError>{
        return await authRepository.deleteAccount()
    }
}
