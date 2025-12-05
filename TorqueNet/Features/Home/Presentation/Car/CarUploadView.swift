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
    @State private var carName = ""
    @State private var carModel = ""
    @State private var rating = 4.8
    @State private var numberOfReviews = ""
    @State private var ownerName = ""
    @State private var ownerRole = ""
    @State private var passengers = ""
    @State private var doors = ""
    @State private var hasAirConditioner = true
    @State private var fuelPolicy = "Full to Full"
    @State private var transmission = "Manual"
    @State private var maxPower = ""
    @State private var zeroToSixty = ""
    @State private var topSpeed = ""
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var loadedImages: [UIImage] = []
    @State private var profileImage: PhotosPickerItem?
    @State private var loadedProfileImage: UIImage?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let fuelPolicies = ["Full to Full", "Same to Same", "Empty to Empty"]
    let transmissionTypes = ["Manual", "Automatic", "Semi-Automatic"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // Image Upload Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Car Images")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            PhotosPicker(selection: $selectedImages, maxSelectionCount: 5, matching: .images) {
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
                            .onChange(of: selectedImages) { newItems in
                                loadImages(from: newItems)
                            }
                            
                            ForEach(loadedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: loadedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Button(action: {
                                        loadedImages.remove(at: index)
                                        selectedImages.remove(at: index)
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
                
                // Basic Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    InputFieldView(
                        description: "Car Name",
                        placeHolder: "Red Mazda 6",
                        text: $carName,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                        }
                    )
                    
                    InputFieldView(
                        description: "Model",
                        placeHolder: "Elite Estate",
                        text: $carModel,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
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
                                Text(String(format: "%.1f", rating))
                                    .font(.custom("Exo2-SemiBold", size: 16))
                                    .foregroundColor(.theme.onSurfaceColor)
                            }
                            Slider(value: $rating, in: 0...5, step: 0.1)
                                .tint(.theme.primaryColor)
                        }
                        InputFieldView(
                            description: "Review",
                            placeHolder: "100",
                            text: $numberOfReviews,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                            }
                        )
                    }
                }
                
                // Owner Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Owner Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    HStack(spacing: 16) {
                        PhotosPicker(selection: $profileImage, matching: .images) {
                            if let loadedProfileImage {
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
                        .onChange(of: profileImage) { newItem in
                            loadProfileImage(from: newItem)
                        }
                        
                        VStack(spacing: 8) {
                            InputFieldView(
                                description: "Owner Name",
                                placeHolder: "John Doe",
                                text: $ownerName,
                                foregroundColor: .theme.onSurfaceColor,
                                backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                                keyboardType: .default,
                                inputFieldStyle: .outlined,
                                onTextChange: {text in
                                }
                            )
                            
                            InputFieldView(
                                description: "Role/Title",
                                placeHolder: "Software Engineer",
                                text: $ownerRole,
                                foregroundColor: .theme.onSurfaceColor,
                                backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                                keyboardType: .default,
                                inputFieldStyle: .outlined,
                                onTextChange: {text in
                                }
                            )
                        }
                    }
                }
                
                // Car Information Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Information")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    HStack(spacing: 12) {
                        InputFieldView(
                            description: "Passengers",
                            placeHolder: "4",
                            text: $passengers,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                            }
                        )
                     
                        InputFieldView(
                            description: "Doors",
                            placeHolder: "4",
                            text: $doors,
                            foregroundColor: .theme.onSurfaceColor,
                            backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                            keyboardType: .numberPad,
                            inputFieldStyle: .outlined,
                            onTextChange: {text in
                            }
                        )
                    }
                    
                    Toggle(isOn: $hasAirConditioner) {
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
                        Picker("Fuel Policy", selection: $fuelPolicy) {
                            ForEach(fuelPolicies, id: \.self) { policy in
                                Text(policy).tag(policy)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transmission")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                        Picker("Transmission", selection: $transmission) {
                            ForEach(transmissionTypes, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                // Car Specifications Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Specifications")
                        .font(.custom("Exo2-Medium", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)
                    
                    InputFieldView(
                        description: "Max Power",
                        placeHolder: "320 Hp",
                        text: $maxPower,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                        }
                    )
                    
                    InputFieldView(
                        description: "0-60 Mph",
                        placeHolder: "5.4 Sec",
                        text: $zeroToSixty,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                        }
                    )

                    InputFieldView(
                        description: "Top Speed",
                        placeHolder: "187 Mph",
                        text: $topSpeed,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                        }
                    )
                }
                
                // Submit Button
                Button(action: submitCarDetails) {
                    Text("Upload Car")
                        .font(.custom("Exo2-SemiBold", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.primaryColor)
                        .cornerRadius(12)
                }
                .padding(.vertical)
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
        .alert("Upload Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadImages(from items: [PhotosPickerItem]) {
        loadedImages.removeAll()
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            loadedImages.append(image)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }
    
    private func loadProfileImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        loadedProfileImage = image
                    }
                }
            case .failure(let error):
                print("Error loading profile image: \(error)")
            }
        }
    }
    
    private func submitCarDetails() {
        // Validate required fields
        guard !carName.isEmpty, !carModel.isEmpty, !ownerName.isEmpty else {
            alertMessage = "Please fill in all required fields"
            showAlert = true
            return
        }
        
        guard loadedImages.count > 0 else {
            alertMessage = "Please add at least one car image"
            showAlert = true
            return
        }
        
        // Here you would typically send the data to your backend
        // For now, we'll just show a success message
        alertMessage = "Car details uploaded successfully!"
        showAlert = true
        
        // Optionally navigate back after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            router.pop()
        }
    }
}

#Preview {
    NavigationView {
        CarUploadView()
    }
}
