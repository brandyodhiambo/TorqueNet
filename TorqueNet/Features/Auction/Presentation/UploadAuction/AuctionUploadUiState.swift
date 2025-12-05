//
//  AuctionUploadUiState.swift
//  TorqueNet
//
//  Created by MAC on 04/12/2025.
//

import SwiftUI

struct AuctionUploadUIState {
    var currentStep: Int = 0
    var showingImagePicker: Bool = false
    var isUploading: Bool = false
    var uploadProgress: Double = 0.0
    
    var errorMessage: String? = nil
    var showError: Bool = false
    var uploadSuccess: Bool = false
    
    var auctionState: FetchState = .good
    var toast: Toast? = nil
}
