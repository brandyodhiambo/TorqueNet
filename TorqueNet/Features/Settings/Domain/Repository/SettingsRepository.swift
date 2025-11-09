//
//  SettingsRepository.swift
//  TorqueNet
//
//  Created by MAC on 24/10/2025.
//
import Foundation
import UIKit


protocol SettingsRepository {
    func fetchUser() async -> Result<User, FirebaseAuthError>
    func uploadProfileImage(_ image: UIImage) async -> Result<String, FirebaseAuthError>
    func updateUserProfileImage(imageUrl: String) async -> Result<Void, FirebaseAuthError>
    func editUser(email: String, phoneNumber: String,name:String,isSeller:Bool) async -> Result<Bool, FirebaseAuthError>
}
