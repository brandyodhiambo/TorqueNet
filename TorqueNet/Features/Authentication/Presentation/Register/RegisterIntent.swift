//
//  RegietsterIntent.swift
//  TorqueNet
//
//  Created by MAC on 13/04/2026.
//

enum RegisterIntent{
    case onFirstNameChange(String)
    case onLastNameChange(String)
    case onPhoneNumberChange(String)
    case onEmailChange(String)
    case onPasswordChange(String)
    case onConfirmPasswordChange(String)
    case register
}
