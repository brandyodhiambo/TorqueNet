//
//  DialogEntity.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation
import SwiftUI

struct DialogEntity {
    var title: String
    var titleColor: Color
    let message: String
    let messageColor: Color
    let icon: String
    let confirmButtonText: String
    let dismissButtonText: String
    var onConfirm: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    init(
        title: String = "",
        titleColor: Color = Color.theme.primaryColor,
        message: String = "",
        messageColor: Color = Color.secondary,
        icon: String = "",
        confirmButtonText: String = "",
        dismissButtonText: String = "",
        onConfirm: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.messageColor = messageColor
        self.titleColor = titleColor
        self.icon = icon
        self.confirmButtonText = confirmButtonText
        self.dismissButtonText = dismissButtonText
        self.onConfirm = onConfirm
        self.onDismiss = onDismiss
    }
}
