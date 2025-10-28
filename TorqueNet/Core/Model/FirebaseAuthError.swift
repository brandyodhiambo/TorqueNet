//
//  FirebaseAuthError.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 06/10/2025.
//

import Foundation

enum FirebaseAuthError: Error, CustomStringConvertible{
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case displayNameUpdateFailed
    case emailVerificationFailed
    case invalidEmailFormat
    case userNotFound
    case userDisabled
    case invalidCredential
    case wrongPassword
    case requiresRecentLogin
    case invalidNonce
    case missingIdentityToken
    case unableToSerializeToken
    case authorizationError
    case custom(String)
    case unknownError
    
    var description: String{
        switch self {
        case .invalidEmail:
            return "Invalid Email"
        case .weakPassword:
            return "The password you entered is too weak. Please choose a stronger password."
        case .emailAlreadyInUse:
            return "The email address you entered is already in use. Please try a different email."
        case .displayNameUpdateFailed:
            return "Display Name Update Failed"
        case .emailVerificationFailed:
            return "Email Verification Failed"
        case .invalidEmailFormat:
             return "The email address you entered is invalid. Please enter a valid email address."
        case .userNotFound:
          return "The user account you are trying to access could not be found."
        case .userDisabled:
          return "The user account you are trying to access has been disabled."
        case .invalidCredential:
          return "The credential used to sign in is invalid."
        case .wrongPassword:
          return "The password you entered is incorrect. Please try again."
        case .invalidNonce:
            return "Invalid Nonce"
        case .missingIdentityToken:
            return "Missing Identity Token"
        case .unableToSerializeToken:
            return "Unable ToSerialize Token"
        case .authorizationError:
            return "Authorization Error"
        case .requiresRecentLogin:
            return "Requires Recent Login"
        case .custom(let error):
            return error
        case .unknownError:
            return "Unknown Error"
        }
    }
}
