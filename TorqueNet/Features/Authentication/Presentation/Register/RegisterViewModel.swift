//
//  RegisterViewModel.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 07/10/2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase



@MainActor
class RegisterViewModel: ObservableObject {
    @Published private var firstName: String = ""
    @Published private var lastName: String = ""
    @Published private var email: String = ""
    @Published private var phoneNumber: String = ""
    @Published private var password: String = ""
    @Published private var confirmPassword: String = ""
}
