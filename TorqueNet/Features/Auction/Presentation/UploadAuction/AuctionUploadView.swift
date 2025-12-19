//
//  AuctionUploadView.swift
//  TorqueNet
//
//  Created by MAC on 15/09/2025.
//

import SwiftUI

struct AuctionUploadView: View {
    @EnvironmentObject var router: Router
    @StateObject var uploadAuctionViewModel = AuctionUploadViewModel()
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Progress Header
                    progressHeader
                    
                    // Content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            switch uploadAuctionViewModel.ui.currentStep {
                            case 0:
                                imagesAndBasicInfoStep
                            case 1:
                                specificationsStep
                            case 2:
                                featuresStep
                            case 3:
                                historyAndInspectionStep
                            case 4:
                                reviewStep
                            default:
                                imagesAndBasicInfoStep
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                    
                    // Navigation Buttons
                    navigationButtons
                }
              
            }
            .toastView(toast: $uploadAuctionViewModel.ui.toast)
            .background(Color.theme.surfaceColor)
            .customTopAppBar(
                title: "Upload Auction",
                leadingIcon: "chevron.left",
                onLeadingTap: {
                    if uploadAuctionViewModel.ui.currentStep > 0 {
                        uploadAuctionViewModel.ui.currentStep -= 1
                } else {
                    router.pop()
                }},
                trailingIcon: "",
                onTrailingTap: {
                    //save
                },
                trailingMenu: {
                  
                }
            )
            .fullScreenProgressOverlay(isShowing: uploadAuctionViewModel.ui.auctionState == .isLoading )
            .sheet(isPresented: $uploadAuctionViewModel.ui.showingImagePicker) {
                ImagePicker(
                    image: .constant(nil),
                    onSave: { image in
                        if let image = image {
                            uploadAuctionViewModel.addImage(image: image)
                        }
                    }
                )
            }
    }
    
    private var progressHeader: some View {
        VStack(spacing: 16) {
            // Progress Indicator
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<uploadAuctionViewModel.steps.count, id: \.self) { index in
                        HStack(spacing: 0) {
                            Circle()
                                .fill(index <= uploadAuctionViewModel.ui.currentStep ? Color.theme.primaryColor : Color.theme.onSurfaceColor.opacity(0.3))
                                .frame(width: 8, height: 8)
                            
                            if index < uploadAuctionViewModel.steps.count - 1 {
                                Rectangle()
                                    .fill(index < uploadAuctionViewModel.ui.currentStep ? Color.theme.primaryColor : Color.theme.onSurfaceColor.opacity(0.3))
                                    .frame(height: 2)
                            }
                        }
                    }
                }
                
                
                Text("\(uploadAuctionViewModel.ui.currentStep + 1) of \(uploadAuctionViewModel.steps.count): \(uploadAuctionViewModel.steps[uploadAuctionViewModel.ui.currentStep])")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
        .background(.ultraThinMaterial)
    }
    
    private var imagesAndBasicInfoStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Vehicle Images", subtitle: "Add at least 3 high-quality photos")
            
            VStack(spacing: 16) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(0..<6, id: \.self) { index in
                            ImageCell(
                                index: index,
                                selectedImages: $uploadAuctionViewModel.form.selectedImages,
                                showingImagePicker: $uploadAuctionViewModel.ui.showingImagePicker,
                                activeImageIndex: $uploadAuctionViewModel.form.activeImageIndex
                            )
                        }
                    }
            }
            
            SectionHeader(title: "Basic Information", subtitle: "Essential details about your vehicle")
            
            VStack(spacing: 16) {
                InputFieldView(
                    description: "Car Title",
                    placeHolder: "2023 BMW X5 M Competition",
                    text: $uploadAuctionViewModel.form.carTitle,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateCarTitle(value: text)
                    }
                )
                
                InputFieldView(
                    description: "Subtitle",
                    placeHolder: "Elite Performance SUV",
                    text: $uploadAuctionViewModel.form.subtitle,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateSubtitle(value: text)
                    }
                )
                
                InputFieldView(
                    description: "Lot Number",
                    placeHolder: "2847",
                    text: $uploadAuctionViewModel.form.lotNumber,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .numberPad,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateLotNumber(value: text)
                    }
                )
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Vehicle Rating")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    HStack {
                        Slider(value: $uploadAuctionViewModel.form.rating, in: 1...5, step: 0.1)
                            .accentColor(.theme.primaryColor)
                        
                        Text(String(format: "%.1f", uploadAuctionViewModel.form.rating))
                            .font(.custom("Exo2-SemiBold", size: 16))
                            .foregroundColor(.theme.primaryColor)
                            .frame(width: 40)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
                
                InputFieldView(
                    description: "Starting Bid ($)",
                    placeHolder: "85500",
                    text: $uploadAuctionViewModel.form.startingBid,
                    foregroundColor: .theme.surfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .numberPad,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateStartingBid(value: text)
                    }
                )
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Auction End Date")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    DatePicker("", selection: $uploadAuctionViewModel.form.auctionEndDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Auction Status")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Picker("Status", selection: $uploadAuctionViewModel.form.auctionStatus) {
                        ForEach(UploadAuctionStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }
        }
    }
    
    private var specificationsStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Key Specifications", subtitle: "Core vehicle specifications")
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Mileage",
                        placeHolder: "12,450",
                        text: $uploadAuctionViewModel.form.mileage,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateMileage(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Year",
                        placeHolder: "2025",
                        text: $uploadAuctionViewModel.form.year,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateYear(value: text)
                        }
                    )
                }
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Engine",
                        placeHolder: "4.4L Twin-Turbo V8",
                        text: $uploadAuctionViewModel.form.engine,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateEngine(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Transformation",
                        placeHolder: "8-Speed Automatic",
                        text: $uploadAuctionViewModel.form.transmission,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateTransmission(value: text)
                        }
                    )
                }
            }
            
            SectionHeader(title: "Detailed Information", subtitle: "Complete vehicle details")
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Make",
                        placeHolder: "BMW",
                        text: $uploadAuctionViewModel.form.make,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateMake(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Model",
                        placeHolder: "X5 M Competition",
                        text: $uploadAuctionViewModel.form.model,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateModel(value: text)
                        }
                    )
                }
                
                InputFieldView(
                    description: "Drivetrain",
                    placeHolder: "All-Wheel Drive",
                    text: $uploadAuctionViewModel.form.drivetrain,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateDriveTrain(value: text)
                    }
                )
                
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Exterior Color",
                        placeHolder: "Storm Bay Metallic",
                        text: $uploadAuctionViewModel.form.exteriorColor,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateExteriorColor(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Interior Color",
                        placeHolder: "Black Merino Leather",
                        text: $uploadAuctionViewModel.form.interiorColor,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateInteriorColor(value: text)
                        }
                    )
                }
                
                InputFieldView(
                    description: "VIN",
                    placeHolder: "5UXCR6C0XP9D12345",
                    text: $uploadAuctionViewModel.form.vin,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateVin(value: text)
                    }
                )
                
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Location",
                        placeHolder: "Los Angeles, CA",
                        text: $uploadAuctionViewModel.form.location,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateLocation(value: text)
                        }
                    )
                    
                    InputFieldView(
                        description: "Seller",
                        placeHolder: "Premium Auto Gallery",
                        text: $uploadAuctionViewModel.form.seller,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in
                            uploadAuctionViewModel.updateSeller(value: text)
                        }
                    )
                }
            }
        }
    }
    
    private var featuresStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Vehicle Features", subtitle: "Add features by category")
            
            // Feature Category Picker
            Picker("Category", selection: $uploadAuctionViewModel.form.selectedFeatureCategory) {
                Text("Performance").tag(0)
                Text("Technology").tag(1)
                Text("Comfort").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            
            // Add Feature Input
            HStack {
                TextField("Add a feature...", text: $uploadAuctionViewModel.form.newFeature)
                    .font(.custom("Exo2-Regular", size: 16))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                
                Button(action: uploadAuctionViewModel.addFeature) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.theme.primaryColor)
                }
                .disabled(uploadAuctionViewModel.form.newFeature.isEmpty)
            }
            
            // Features Display
            VStack(alignment: .leading, spacing: 16) {
                if !uploadAuctionViewModel.form.performanceFeatures.isEmpty {
                    FeatureGroupEditor(title: "Performance", features: $uploadAuctionViewModel.form.performanceFeatures)
                }
                
                if !uploadAuctionViewModel.form.technologyFeatures.isEmpty {
                    FeatureGroupEditor(title: "Technology", features: $uploadAuctionViewModel.form.technologyFeatures)
                }
                
                if !uploadAuctionViewModel.form.comfortFeatures.isEmpty {
                    FeatureGroupEditor(title: "Comfort & Convenience", features: $uploadAuctionViewModel.form.comfortFeatures)
                }
            }
        }
    }
    
    private var historyAndInspectionStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Vehicle History", subtitle: "Add important history events")
            
            Button(action: {
                //MARK: PASS date, events, details
                uploadAuctionViewModel.addHistoryEvent()
            }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add History Event")
                }
                .font(.custom("Exo2-Medium", size: 16))
                .foregroundColor(.theme.primaryColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12).stroke(Color.theme.primaryColor, lineWidth: 1)
                )
            }
            
            ForEach(uploadAuctionViewModel.form.historyEvents.indices, id: \.self) { index in
                HistoryEventEditor(event: $uploadAuctionViewModel.form.historyEvents[index]) {
                    uploadAuctionViewModel.removeHistoryEvent(at: index)
                }
            }
            
            SectionHeader(title: "Inspection Report", subtitle: "Rate each category from 1-10")
            
            VStack(spacing: 16) {
                InspectionRatingEditor(title: "Exterior", rating: $uploadAuctionViewModel.form.exteriorRating, details: $uploadAuctionViewModel.form.exteriorDetails)
                InspectionRatingEditor(title: "Interior", rating: $uploadAuctionViewModel.form.interiorRating, details: $uploadAuctionViewModel.form.interiorDetailsText)
                InspectionRatingEditor(title: "Engine", rating: $uploadAuctionViewModel.form.engineRating, details: $uploadAuctionViewModel.form.engineDetails)
                InspectionRatingEditor(title: "Transmission", rating: $uploadAuctionViewModel.form.transmissionRating, details: $uploadAuctionViewModel.form.transmissionDetails)
                InspectionRatingEditor(title: "Electronics", rating: $uploadAuctionViewModel.form.electronicsRating, details: $uploadAuctionViewModel.form.electronicsDetails)
            }
        }
    }
    
    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Review Your Auction", subtitle: "Verify all information before submitting")
            
            VStack(spacing: 20) {
                ReviewCard(title: "Basic Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(uploadAuctionViewModel.form.carTitle) - \(uploadAuctionViewModel.form.subtitle)")
                            .font(.custom("Exo2-SemiBold", size: 16))
                        Text("Lot #\(uploadAuctionViewModel.form.lotNumber) • Rating: \(String(format: "%.1f", uploadAuctionViewModel.form.rating))")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                        Text("Starting Bid: $\(uploadAuctionViewModel.form.startingBid)")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.primaryColor)
                    }
                }
                
                ReviewCard(title: "Specifications") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(uploadAuctionViewModel.form.year) \(uploadAuctionViewModel.form.make) \(uploadAuctionViewModel.form.model)")
                            .font(.custom("Exo2-Medium", size: 14))
                        Text("\(uploadAuctionViewModel.form.mileage) miles • \(uploadAuctionViewModel.form.engine)")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                    }
                }
                
                ReviewCard(title: "Images") {
                    Text("\(uploadAuctionViewModel.form.selectedImages.count) photos uploaded")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                ReviewCard(title: "Features") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(uploadAuctionViewModel.form.performanceFeatures.count) Performance features")
                        Text("\(uploadAuctionViewModel.form.technologyFeatures.count) Technology features")
                        Text("\(uploadAuctionViewModel.form.comfortFeatures.count) Comfort features")
                    }
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if uploadAuctionViewModel.ui.currentStep > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        uploadAuctionViewModel.ui.currentStep -= 1
                    }
                }) {
                    Text("Previous")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.theme.onSurfaceColor.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            
            Spacer()
            
            Button(action: {
                if uploadAuctionViewModel.ui.currentStep < uploadAuctionViewModel.steps.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        uploadAuctionViewModel.ui.currentStep += 1
                    }
                } else {
                    Task{
                        await uploadAuctionViewModel.submitAuction(
                            onSuccess: {
                                uploadAuctionViewModel.ui.toast = Toast(style: .success, message: "Auction Uploaded successfully")
                            },
                            onFailure: {error in
                                uploadAuctionViewModel.ui.toast = Toast(style: .error, message: error)
                            }
                        )
                    }
                }
            }) {
                Text(uploadAuctionViewModel.ui.currentStep == uploadAuctionViewModel.steps.count - 1 ? "Submit Auction" : "Next")
                    .font(.custom("Exo2-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(uploadAuctionViewModel.canProceed ? Color.theme.primaryColor: Color.theme.onSurfaceColor.opacity(0.7) )
                            .shadow(color: .theme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
            }
            .disabled(!uploadAuctionViewModel.canProceed)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
    
}


struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Exo2-Bold", size: 20))
                .foregroundColor(.theme.onSurfaceColor)
            
            Text(subtitle)
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
        }
    }
}

struct FeatureGroupEditor: View {
    let title: String
    @Binding var features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            
            ForEach(features.indices, id: \.self) { index in
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    
                    Text(features[index])
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Spacer()
                    
                    Button(action: {
                        features.remove(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
            }
        }
    }
}


struct HistoryEventEditor: View {
    @Binding var event: HistoryEventData
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("History Event")
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            TextField("Date (e.g., March 2023)", text: $event.date)
                .font(.custom("Exo2-Regular", size: 14))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
            
            TextField("Event (e.g., Vehicle Manufactured)", text: $event.event)
                .font(.custom("Exo2-Regular", size: 14))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
            
            TextField("Details", text: $event.details)
                .font(.custom("Exo2-Regular", size: 14))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.onSurfaceColor.opacity(0.2), lineWidth: 1)
        )
    }
}

struct InspectionRatingEditor: View {
    let title: String
    @Binding var rating: Double
    @Binding var details: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Spacer()
                
                Text(String(format: "%.1f/10", rating))
                    .font(.custom("Exo2-SemiBold", size: 14))
                    .foregroundColor(rating > 9 ? .green : rating > 7 ? .orange : .red)
            }
            
            Slider(value: $rating, in: 1...10, step: 0.1)
                .accentColor(.theme.primaryColor)
            
            TextField("Inspection details...", text: $details)
                .font(.custom("Exo2-Regular", size: 14))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ReviewCard: View {
    let title: String
    let content: () -> AnyView
    
    init(title: String, @ViewBuilder content: @escaping () -> some View) {
        self.title = title
        self.content = { AnyView(content()) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ImageCell: View {
    let index: Int
    @Binding var selectedImages: [UIImage]
    @Binding var showingImagePicker: Bool
    @Binding var activeImageIndex: Int?
    
    var body: some View {
        if index < selectedImages.count {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: selectedImages[index])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        activeImageIndex = index
                        showingImagePicker = true
                    }
                
                Button {
                    selectedImages.remove(at: index)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .background(.white, in: Circle())
                        .font(.system(size: 20))
                }
                .padding(8)
            }
        } else {
            Button {
                activeImageIndex = nil
                showingImagePicker = true
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: selectedImages.isEmpty ? "camera.fill" : "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.theme.primaryColor)
                    
                    Text(selectedImages.isEmpty ? "Add Photos" : "Add More")
                        .font(.custom("Exo2-Medium", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.primaryColor.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [8]))
                )
            }
        }
    }
}


#Preview {
    NavigationView{
        AuctionUploadView()
    }
}
