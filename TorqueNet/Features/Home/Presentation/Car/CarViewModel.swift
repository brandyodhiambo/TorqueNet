//
//  CarViewModel.swift
//  TorqueNet
//
//  Created by MAC on 08/12/2025.
//


import Foundation
import UIKit
import SwiftUI

@MainActor
class CarViewModel: ObservableObject {
    @Published var carUiState = CarUiState()
}
