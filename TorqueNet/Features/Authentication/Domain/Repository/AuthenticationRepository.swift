//
//  AuthenticationRepository.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 06/10/2025.
//
import Foundation
import FirebaseAuth

protocol AuthenticationRepository{
    func signUpUser(name:String,email: String, password: String,phoneNumber:String) async -> Result<AuthDataResult,FirebaseAuthError>
    func signInUser(email: String, password: String) async -> Result<AuthDataResult,FirebaseAuthError>
    func googleSignIn() async -> Result<AuthDataResult,FirebaseAuthError>
    func forgotPassword(email: String) async -> Result<Bool,FirebaseAuthError>
    func logoutUser() async -> Result<Bool,FirebaseAuthError>
    func deleteAccount() async -> Result<Bool,FirebaseAuthError>
    func changePassword(currentPassword: String, newPassword: String) async -> Result<Bool, FirebaseAuthError>
}
