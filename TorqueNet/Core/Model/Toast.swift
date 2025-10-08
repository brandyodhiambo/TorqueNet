//
//  Toast.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
