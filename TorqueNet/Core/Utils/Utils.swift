//
//  Utils.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//
import Foundation
import SwiftUI

struct Utils {
    static let shared = Utils()
    // Dismiss keyboard
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
