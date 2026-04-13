//
//  LoginIntent.swift
//  TorqueNet
//
//  Created by MAC on 10/04/2026.
//

enum LoginIntent {
    case onEmailChange(String)
    case onPasswordChange(String)
    case onRememberMe(Bool)
    case login
}
