//
//  LoginState.swift
//  TorqueNet
//
//  Created by MAC on 04/12/2025.
//

struct LoginState{
    var dialogEntity = DialogEntity()
    var isShowAlertDialog = false
    var email: String = ""
    var password: String = ""
    var rememberMe: Bool = false
    var isLoginEnable: Bool = false
    var loginErrors = [String: String]()
    var loginState: FetchState = FetchState.good
}
