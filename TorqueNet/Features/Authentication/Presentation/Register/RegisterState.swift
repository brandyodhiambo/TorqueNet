//
//  RegisterState.swift
//  TorqueNet
//
//  Created by MAC on 04/12/2025.
//

struct RegisterState{
    var dialogEntity = DialogEntity()
    var isShowAlertDialog = false
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isRegisterEnabled: Bool = false
    var registerErrors = [String: String]()
    var registeState: FetchState = FetchState.good
}
