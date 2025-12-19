//
//  UploadCarView.swift
//  TorqueNet
//
//  Created by MAC on 03/12/2025.
//

import SwiftUI
import PhotosUI

struct CarUploadView: View {
    @EnvironmentObject var router: Router
    @StateObject var carViewModel = CarViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Car Images")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            PhotosPicker(selection: $carViewModel.carUiState.selectedImages, maxSelectionCount: 5, matching: .images) {
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.theme.primaryColor)
                                    Text("Add Photos")
                                        .font(.custom("Exo2-Regular", size: 12))
                                        .foregroundColor(.theme.onSurfaceColor)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.theme.surfaceColor)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.theme.primaryColor.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                )
                            }
                            .onChange(of: carViewModel.carUiState.selectedImages) { newItems in
                                carViewModel.loadImages(from: newItems)
                            }
                            
                            ForEach(carViewModel.carUiState.loadedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: carViewModel.carUiState.loadedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Button(action: {
                                        carViewModel.carUiState.loadedImages.remove(at: index)
                                        carViewModel.carUiState.selectedImages.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Circle().fill(Color.white))
                                    }
                                    .padding(8)
                                }
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    InputFieldView(
                        description: "Car Name",
                        placeHolder: "Red Mazda 6",
                        text: $carViewModel.carUiState.carName,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        errorMessage: carViewModel.carUiState.carErrors["carName"] ?? "",
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            carViewModel.updateCarName(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Model",
                        placeHolder: "Elite Estate",
                        text: $carViewModel.carUiState.carModel,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        errorMessage: carViewModel.carUiState.carErrors["carModel"] ?? "",
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            carViewModel.updateCarModel(value: text)
                        }
                    )
                    
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rating")
                                .font(.custom("Exo2-Regular", size: 14))
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", carViewModel.carUiState.rating))
                                    .font(.custom("Exo2-SemiBold", size: 16))
                                    .foregroundColor(.theme.onSurfaceColor)
                            }
                            Slider(value: $carViewModel.carUiState.rating, in: 0...5, step: 0.1)
                                .tint(.theme.primaryColor)
                        }
                        InputFieldView(
                            description: "Review",
                            placeHolder: "100",
                            text: $carViewModel.carUiState.numberOfReviews,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            errorMessage: carViewModel.carUiState.carErrors["numberOfReviews"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                                carViewModel.updateNumberOfReviews(value: text)
                            }
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Owner Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    HStack(spacing: 16) {
                        PhotosPicker(selection: $carViewModel.carUiState.profileImage, matching: .images) {
                            if let loadedProfileImage = carViewModel.carUiState.loadedProfileImage {
                                Image(uiImage: loadedProfileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.theme.surfaceColor)
                                        .frame(width: 70, height: 70)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.theme.primaryColor.opacity(0.3), lineWidth: 2)
                                        )
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .font(.system(size: 30))
                                        .foregroundColor(.theme.primaryColor)
                                }
                            }
                        }
                        .onChange(of: carViewModel.carUiState.profileImage) { newItem in
                            carViewModel.loadProfileImage(from: newItem)
                        }
                        
                        VStack(spacing: 8) {
                            InputFieldView(
                                description: "Owner Name",
                                placeHolder: "John Doe",
                                text: $carViewModel.carUiState.ownerName,
                                foregroundColor: .theme.onSurfaceColor,
                                backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                                keyboardType: .default,
                                errorMessage: carViewModel.carUiState.carErrors["ownerName"] ?? "",
                                inputFieldStyle: .outlined,
                                onTextChange: {text in
                                    carViewModel.updateOwnerName(value: text)
                                }
                            )
                            
                            InputFieldView(
                                description: "Role/Title",
                                placeHolder: "Software Engineer",
                                text: $carViewModel.carUiState.ownerRole,
                                foregroundColor: .theme.onSurfaceColor,
                                backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                                keyboardType: .default,
                                errorMessage: carViewModel.carUiState.carErrors["ownerRole"] ?? "",
                                inputFieldStyle: .outlined,
                                onTextChange: {text in
                                    carViewModel.updateOwnerRole(value: text)
                                }
                            )
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    HStack(spacing: 12) {
                        InputFieldView(
                            description: "Passengers",
                            placeHolder: "4",
                            text: $carViewModel.carUiState.passengers,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            errorMessage: carViewModel.carUiState.carErrors["passengers"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                                carViewModel.updatePassengers(value: text)
                            }
                        )
                        
                        InputFieldView(
                            description: "Doors",
                            placeHolder: "4",
                            text: $carViewModel.carUiState.doors,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            errorMessage: carViewModel.carUiState.carErrors["doors"] ?? "",
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                                carViewModel.updateDoors(value: text)
                            }
                        )
                    }
                    
                    Toggle(isOn: $carViewModel.carUiState.hasAirConditioner) {
                        HStack(spacing: 8) {
                            Image(systemName: "snowflake")
                                .foregroundColor(.theme.primaryColor)
                            Text("Air Conditioner")
                                .font(.custom("Exo2-Regular", size: 14))
                                .foregroundColor(.theme.onSurfaceColor)
                        }
                    }
                    .tint(.theme.primaryColor)
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fuel Policy")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                        Picker("Fuel Policy", selection: $carViewModel.carUiState.fuelPolicy) {
                            ForEach(carViewModel.carUiState.fuelPolicies, id: \.self) { policy in
                                Text(policy).tag(policy)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transmission")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                        Picker("Transmission", selection: $carViewModel.carUiState.transmission) {
                            ForEach(carViewModel.carUiState.transmissionTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Specifications")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    InputFieldView(
                        description: "Max Power",
                        placeHolder: "320 Hp",
                        text: $carViewModel.carUiState.maxPower,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        errorMessage: carViewModel.carUiState.carErrors["maxPower"] ?? "",
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            carViewModel.updateMaxPower(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "0-60 Mph",
                        placeHolder: "5.4 Sec",
                        text: $carViewModel.carUiState.zeroToSixty,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        errorMessage: carViewModel.carUiState.carErrors["zeroToSixty"] ?? "",
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            carViewModel.updateZeroToSixty(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Top Speed",
                        placeHolder: "187 Mph",
                        text: $carViewModel.carUiState.topSpeed,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        errorMessage: carViewModel.carUiState.carErrors["topSpeed"] ?? "",
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            carViewModel.updateTopSpeed(value: text)
                        }
                    )
                }
                
                CustomButtonView(
                    buttonName:"Upload Car",
                    isDisabled: !carViewModel.carUiState.isButtonEnable,
                    onTap: {
                        Task{
                            await carViewModel.uploadCar(
                                onSuccess:{
                                    carViewModel.carUiState.toast = Toast(style: .success, message: "You have successfully uploaded a car.")
                                },
                                onFailure:{ error in
                                    carViewModel.carUiState.toast = Toast(style: .error, message: error)
                                }
                            )
                        }
                    }
                )
            }
            .padding()
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Upload Car",
            leadingIcon: "chevron.left",
            navbarTitleDisplayMode: .inline,
            onLeadingTap: {
                router.pop()
            },
            trailingIcon: "",
            onTrailingTap: {},
            trailingMenu: {}
        )
        .fullScreenProgressOverlay(isShowing: carViewModel.carUiState.carState == .isLoading )
        .toastView(toast: $carViewModel.carUiState.toast)
    }
}

#Preview {
    NavigationView {
        CarUploadView()
    }
}
