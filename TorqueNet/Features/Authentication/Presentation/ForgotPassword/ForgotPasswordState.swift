//
//  ForgotPasswordState.swift
//  TorqueNet
//
//  Created by MAC on 10/04/2026.
//

struct ForgotPasswordState{
    var email:String = ""
    var dialogEntity = DialogEntity()
    var isShowAlertDialog = false
    var isForgotPasswordEnable: Bool = false
    var forgotPasswordErrors = [String: String]()
    var forgotPasswordState: FetchState = FetchState.good
}
