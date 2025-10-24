//
//  SettingsRepository.swift
//  TorqueNet
//
//  Created by MAC on 24/10/2025.
//
import Foundation

protocol SettingsRepository{
    func fetchUser() async -> Result<User, FirebaseAuthError>
}
