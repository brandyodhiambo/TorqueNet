//
//  AuctionUploadView.swift
//  TorqueNet
//
//  Created by MAC on 15/09/2025.
//

import SwiftUI

struct AuctionUploadView: View {
    @ObservedObject var uploadAuctionViewModel = UploadAuctionViewModel()
    
    // Key Specs
    @State private var mileage = ""
    @State private var year = ""
    @State private var engine = ""
    @State private var transmission = ""
    
    // Vehicle Details
    @State private var make = ""
    @State private var model = ""
    @State private var drivetrain = ""
    @State private var exteriorColor = ""
    @State private var interiorColor = ""
    @State private var vin = ""
    @State private var location = ""
    @State private var seller = ""
    
    // Features
    @State private var performanceFeatures: [String] = []
    @State private var technologyFeatures: [String] = []
    @State private var comfortFeatures: [String] = []
    @State private var newFeature = ""
    @State private var selectedFeatureCategory = 0
    @EnvironmentObject var router: Router
    
    // History
    @State private var historyEvents: [HistoryEventData] = []
    
    // Inspection
    @State private var exteriorRating = 9.0
    @State private var exteriorDetails = ""
    @State private var interiorRating = 9.0
    @State private var interiorDetailsText = ""
    @State private var engineRating = 9.0
    @State private var engineDetails = ""
    @State private var transmissionRating = 9.0
    @State private var transmissionDetails = ""
    @State private var electronicsRating = 9.0
    @State private var electronicsDetails = ""
    
    private let steps = [
        "Images & Basic Info",
        "Specifications",
        "Features",
        "History & Inspection",
        "Review & Submit"
    ]
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Progress Header
                    progressHeader
                    
                    // Content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            switch uploadAuctionViewModel.currentStep {
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
            .background(Color.theme.surfaceColor)
            .customTopAppBar(
                title: "Upload Auction",
                leadingIcon: "chevron.left",
                onLeadingTap: {
                    if uploadAuctionViewModel.currentStep > 0 {
                        uploadAuctionViewModel.currentStep -= 1
                } else {
                    router.pop()
                }},
                trailingIcon: "bookmark.fill",
                onTrailingTap: {
                    //save
                },
                trailingMenu: {
                  
                }
            )
            .sheet(isPresented: $uploadAuctionViewModel.showingImagePicker) {
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
    
    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: 16) {
            // Progress Indicator
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        HStack(spacing: 0) {
                            Circle()
                                .fill(index <= uploadAuctionViewModel.currentStep ? Color.theme.primaryColor : Color.theme.onSurfaceColor.opacity(0.3))
                                .frame(width: 8, height: 8)
                            
                            if index < steps.count - 1 {
                                Rectangle()
                                    .fill(index < uploadAuctionViewModel.currentStep ? Color.theme.primaryColor : Color.theme.onSurfaceColor.opacity(0.3))
                                    .frame(height: 2)
                            }
                        }
                    }
                }
                
                
                Text("\(uploadAuctionViewModel.currentStep + 1) of \(steps.count): \(steps[uploadAuctionViewModel.currentStep])")
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
                                selectedImages: $uploadAuctionViewModel.selectedImages,
                                showingImagePicker: $uploadAuctionViewModel.showingImagePicker,
                                activeImageIndex: $uploadAuctionViewModel.activeImageIndex
                            )
                        }
                    }
            }
            
            SectionHeader(title: "Basic Information", subtitle: "Essential details about your vehicle")
            
            VStack(spacing: 16) {
                InputFieldView(
                    description: "Car Title",
                    placeHolder: "2023 BMW X5 M Competition",
                    text: $uploadAuctionViewModel.carTitle,
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
                    text: $uploadAuctionViewModel.subtitle,
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
                    text: $uploadAuctionViewModel.lotNumber,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
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
                        Slider(value: $uploadAuctionViewModel.rating, in: 1...5, step: 0.1)
                            .accentColor(.theme.primaryColor)
                        
                        Text(String(format: "%.1f", uploadAuctionViewModel.rating))
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
                    text: $uploadAuctionViewModel.startingBid,
                    foregroundColor: .theme.surfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in
                        uploadAuctionViewModel.updateStartingBid(value: text)
                    }
                )
                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Auction End Date")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    DatePicker("", selection: $uploadAuctionViewModel.auctionEndDate, displayedComponents: [.date, .hourAndMinute])
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
                    
                    Picker("Status", selection: $uploadAuctionViewModel.auctionStatus) {
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
    
    // MARK: - Step 2: Specifications
    private var specificationsStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Key Specifications", subtitle: "Core vehicle specifications")
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Mileage",
                        placeHolder: "12,450",
                        text: $mileage,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                    
                    InputFieldView(
                        description: "Year",
                        placeHolder: "2025",
                        text: $year,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                }
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Engine",
                        placeHolder: "4.4L Twin-Turbo V8",
                        text: $engine,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                    
                    InputFieldView(
                        description: "Transformation",
                        placeHolder: "8-Speed Automatic",
                        text: $transmission,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                }
            }
            
            SectionHeader(title: "Detailed Information", subtitle: "Complete vehicle details")
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Make",
                        placeHolder: "BMW",
                        text: $make,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                    
                    InputFieldView(
                        description: "Model",
                        placeHolder: "X5 M Competition",
                        text: $model,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                }
                
                InputFieldView(
                    description: "Drivetrain",
                    placeHolder: "All-Wheel Drive",
                    text: $drivetrain,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in}
                )
                
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Exterior Color",
                        placeHolder: "Storm Bay Metallic",
                        text: $exteriorColor,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                    
                    InputFieldView(
                        description: "Interior Color",
                        placeHolder: "Black Merino Leather",
                        text: $interiorColor,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                }
                
                InputFieldView(
                    description: "VIN",
                    placeHolder: "5UXCR6C0XP9D12345",
                    text: $vin,
                    foregroundColor: .theme.onSurfaceColor,
                    backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                    keyboardType: .default,
                    inputFieldStyle: .outlined,
                    onTextChange: {text in}
                )
                
                
                HStack(spacing: 16) {
                    InputFieldView(
                        description: "Location",
                        placeHolder: "Los Angeles, CA",
                        text: $location,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                    
                    InputFieldView(
                        description: "Seller",
                        placeHolder: "Premium Auto Gallery",
                        text: $seller,
                        foregroundColor: .theme.onSurfaceColor,
                        backgroundColor: .theme.onSurfaceColor.opacity(0.1),
                        keyboardType: .default,
                        inputFieldStyle: .outlined,
                        onTextChange: {text in}
                    )
                }
            }
        }
    }
    
    private var featuresStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Vehicle Features", subtitle: "Add features by category")
            
            // Feature Category Picker
            Picker("Category", selection: $selectedFeatureCategory) {
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
                TextField("Add a feature...", text: $newFeature)
                    .font(.custom("Exo2-Regular", size: 16))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                
                Button(action: addFeature) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.theme.primaryColor)
                }
                .disabled(newFeature.isEmpty)
            }
            
            // Features Display
            VStack(alignment: .leading, spacing: 16) {
                if !performanceFeatures.isEmpty {
                    FeatureGroupEditor(title: "Performance", features: $performanceFeatures)
                }
                
                if !technologyFeatures.isEmpty {
                    FeatureGroupEditor(title: "Technology", features: $technologyFeatures)
                }
                
                if !comfortFeatures.isEmpty {
                    FeatureGroupEditor(title: "Comfort & Convenience", features: $comfortFeatures)
                }
            }
        }
    }
    
    // MARK: - Step 4: History & Inspection
    private var historyAndInspectionStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Vehicle History", subtitle: "Add important history events")
            
            Button(action: {
                historyEvents.append(HistoryEventData(date: "", event: "", details: ""))
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
            
            ForEach(historyEvents.indices, id: \.self) { index in
                HistoryEventEditor(event: $historyEvents[index]) {
                    historyEvents.remove(at: index)
                }
            }
            
            SectionHeader(title: "Inspection Report", subtitle: "Rate each category from 1-10")
            
            VStack(spacing: 16) {
                InspectionRatingEditor(title: "Exterior", rating: $exteriorRating, details: $exteriorDetails)
                InspectionRatingEditor(title: "Interior", rating: $interiorRating, details: $interiorDetailsText)
                InspectionRatingEditor(title: "Engine", rating: $engineRating, details: $engineDetails)
                InspectionRatingEditor(title: "Transmission", rating: $transmissionRating, details: $transmissionDetails)
                InspectionRatingEditor(title: "Electronics", rating: $electronicsRating, details: $electronicsDetails)
            }
        }
    }
    
    // MARK: - Step 5: Review
    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Review Your Auction", subtitle: "Verify all information before submitting")
            
            VStack(spacing: 20) {
                ReviewCard(title: "Basic Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(uploadAuctionViewModel.carTitle) - \(uploadAuctionViewModel.subtitle)")
                            .font(.custom("Exo2-SemiBold", size: 16))
                        Text("Lot #\(uploadAuctionViewModel.lotNumber) • Rating: \(String(format: "%.1f", uploadAuctionViewModel.rating))")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                        Text("Starting Bid: $\(uploadAuctionViewModel.startingBid)")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.primaryColor)
                    }
                }
                
                ReviewCard(title: "Specifications") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(year) \(make) \(model)")
                            .font(.custom("Exo2-Medium", size: 14))
                        Text("\(mileage) miles • \(engine)")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                    }
                }
                
                ReviewCard(title: "Images") {
                    Text("\(uploadAuctionViewModel.selectedImages.count) photos uploaded")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                ReviewCard(title: "Features") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(performanceFeatures.count) Performance features")
                        Text("\(technologyFeatures.count) Technology features")
                        Text("\(comfortFeatures.count) Comfort features")
                    }
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
            }
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if uploadAuctionViewModel.currentStep > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        uploadAuctionViewModel.currentStep -= 1
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
                if uploadAuctionViewModel.currentStep < steps.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        uploadAuctionViewModel.currentStep += 1
                    }
                } else {
                    // Submit auction
                    submitAuction()
                }
            }) {
                Text(uploadAuctionViewModel.currentStep == steps.count - 1 ? "Submit Auction" : "Next")
                    .font(.custom("Exo2-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(!uploadAuctionViewModel.canProceed ? Color.theme.primaryColor: Color.theme.onSurfaceColor.opacity(0.7) )
                            .shadow(color: .theme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
            }
            .disabled(!uploadAuctionViewModel.canProceed)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Helper Functions    
    private func addFeature() {
        guard !newFeature.isEmpty else { return }
        
        switch selectedFeatureCategory {
        case 0:
            performanceFeatures.append(newFeature)
        case 1:
            technologyFeatures.append(newFeature)
        case 2:
            comfortFeatures.append(newFeature)
        default:
            break
        }
        
        newFeature = ""
    }
    
    private func submitAuction() {
        // Handle auction submission
        print("Auction submitted successfully!")
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

struct HistoryEventData: Identifiable {
    let id = UUID()
    var date: String
    var event: String
    var details: String
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
