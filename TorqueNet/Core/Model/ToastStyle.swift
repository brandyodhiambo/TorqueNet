//
//  ToastStyle.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation
import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case infor
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error:
            return Color.red
        case .warning:
            return Color.orange
        case .success:
            return Color.green
        case .infor:
            return Color.blue
        }
    }
    
    var iconFileName: String {
       switch self {
       case .infor: return "info.circle.fill"
       case .warning: return "exclamationmark.triangle.fill"
       case .success: return "checkmark.circle.fill"
       case .error: return "xmark.circle.fill"
       }
     }
}
