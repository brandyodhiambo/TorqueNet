//
//  AuctionCarDetailView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 11/09/2025.
//

import SwiftUI

struct AuctionCarDetailView: View {
    @State private var selectedImageIndex = 0
    @State private var isFavorite = false
    @State private var bidAmount = ""
    @State private var timeRemaining: TimeInterval = 0
    @State private var showBidSheet = false
    @State private var selectedTab = 0
    @EnvironmentObject var router: Router
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Sample data
    let carImages = ["car", "carKey", "car", "car"]
    let auctionEndDate = Date().addingTimeInterval(3600 * 5)
    
    var body: some View {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header Image Section
                        imageGallerySection
                        
                        // Car Information Section
                        VStack(spacing: 24) {
                            // Title and Basic Info
                            carTitleSection
                            
                            // Auction Status and Bid Info
                            auctionInfoSection
                            
                            // Tab Section
                            tabSection
                            
                            // Content based on selected tab
                            tabContentSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.theme.surfaceColor)
                                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
                        )
                        .offset(y: -30)
                    }
                }
                
                VStack {
                    Spacer()
                    bottomActionBar
                }
                .padding(.horizontal, 20)
            }
            .ignoresSafeArea(edges: .top)
            .background(Color.theme.surfaceColor)
            .padding(.horizontal, 20)
            .onAppear {
                updateTimeRemaining()
            }
            .onReceive(timer) { _ in
                updateTimeRemaining()
            }
        
        .sheet(isPresented: $showBidSheet) {
            BidSheetView(currentBid: 25000, onBidSubmitted: { amount in
                print("Bid submitted: $\(amount)")
            })
        }
    }
    
    // MARK: - Image Gallery Section
    private var imageGallerySection: some View {
        ZStack {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<carImages.count, id: \.self) { index in
                    ZStack {
                        Image(carImages[index])
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea(edges: .top)
                            .tag(index)
                            .clipped()
                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .clear,
                                .black.opacity(0.9)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 450)
            .ignoresSafeArea(edges: .top)
            
            
            // Navigation Controls
            VStack {
                HStack {
                    Button(action: {
                        router.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring()) {
                                isFavorite.toggle()
                            }
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(isFavorite ? .red : .white)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .scaleEffect(isFavorite ? 1.1 : 1.0)
                        
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // Image Indicators
                HStack(spacing: 8) {
                    ForEach(0..<carImages.count, id: \.self) { index in
                        Circle()
                            .fill(selectedImageIndex == index ? .white : .white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(selectedImageIndex == index ? 1.2 : 1.0)
                            .animation(.spring(), value: selectedImageIndex)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .padding(.vertical, 32)
        }
    }
    
    // MARK: - Car Title Section
    private var carTitleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("2023 BMW X5 M Competition")
                        .font(.custom("Exo2-Bold", size: 28))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text("Elite Performance SUV")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Lot #2847")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text("4.8")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                }
            }
            
            // Key Specs
            HStack(spacing: 20) {
                SpecBadge(icon: "speedometer", value: "12,450", unit: "miles")
                SpecBadge(icon: "calendar", value: "2023", unit: "year")
                SpecBadge(icon: "fuelpump.fill", value: "V8", unit: "engine")
                SpecBadge(icon: "gearshape.fill", value: "Auto", unit: "trans")
            }
        }
        .padding(.horizontal,8)

        
    }
    
    // MARK: - Auction Info Section
    private var auctionInfoSection: some View {
        VStack(spacing: 20) {
            // Current Bid and Time Remaining
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Bid")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text("$85,500")
                        .font(.custom("Exo2-Bold", size: 32))
                        .foregroundColor(.theme.primaryColor)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(.green)
                            .font(.system(size: 12))
                        Text("12 bids")
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Auction Ends In")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text(countdownString())
                        .font(.custom("Exo2-Bold", size: 20))
                        .foregroundColor(timeRemaining > 3600 ? .green : .orange)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Live Bidding")
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                    }
                }
            }
            
            // Bid History Preview
            bidHistoryPreview
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - Bid History Preview
    private var bidHistoryPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Bids")
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(spacing: 8) {
                BidRowView(bidder: "User****2847", amount: 85500, time: "2m ago", isHighest: true)
                BidRowView(bidder: "Auto****1234", amount: 84000, time: "5m ago", isHighest: false)
                BidRowView(bidder: "Coll****9876", amount: 82500, time: "8m ago", isHighest: false)
            }
            
            Button(action: {}) {
                Text("View All Bids")
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.primaryColor)
            }
        }
    }
    
    // MARK: - Tab Section
    private var tabSection: some View {
        HStack {
            TabButton(title: "Details", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabButton(title: "Features", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            TabButton(title: "History", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            TabButton(title: "Inspection", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
        }
    }
    
    // MARK: - Tab Content
    private var tabContentSection: some View {
        Group {
            switch selectedTab {
            case 0:
                detailsTabContent
            case 1:
                featuresTabContent
            case 2:
                historyTabContent
            case 3:
                inspectionTabContent
            default:
                detailsTabContent
            }
        }
    }
    
    // MARK: - Details Tab
    private var detailsTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            DetailRow(label: "Make", value: "BMW")
            DetailRow(label: "Model", value: "X5 M Competition")
            DetailRow(label: "Year", value: "2023")
            DetailRow(label: "Mileage", value: "12,450 miles")
            DetailRow(label: "Engine", value: "4.4L Twin-Turbo V8")
            DetailRow(label: "Transmission", value: "8-Speed Automatic")
            DetailRow(label: "Drivetrain", value: "All-Wheel Drive")
            DetailRow(label: "Exterior Color", value: "Storm Bay Metallic")
            DetailRow(label: "Interior Color", value: "Black Merino Leather")
            DetailRow(label: "VIN", value: "5UXCR6C0XP9D12345")
            DetailRow(label: "Location", value: "Los Angeles, CA")
            DetailRow(label: "Seller", value: "Premium Auto Gallery")
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Features Tab
    private var featuresTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            FeatureGroup(title: "Performance", features: [
                "617 HP Twin-Turbo V8 Engine",
                "M xDrive All-Wheel Drive",
                "M Sport Differential",
                "Adaptive M Suspension",
                "M Sport Exhaust System"
            ])
            
            FeatureGroup(title: "Technology", features: [
                "12.3\" Digital Instrument Display",
                "12.3\" Touchscreen iDrive 7.0",
                "Wireless Apple CarPlay",
                "Harman Kardon Premium Audio",
                "360-Degree Camera System"
            ])
            
            FeatureGroup(title: "Comfort & Convenience", features: [
                "Heated & Ventilated Front Seats",
                "Massage Function",
                "Panoramic Sunroof",
                "Ambient Lighting",
                "Wireless Phone Charging"
            ])
        }
        
    }
    
    // MARK: - History Tab
    private var historyTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vehicle History")
                .font(.custom("Exo2-SemiBold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(spacing: 12) {
                HistoryEvent(date: "March 2023", event: "Vehicle Manufactured", details: "BMW Manufacturing Plant, South Carolina")
                HistoryEvent(date: "April 2023", event: "First Owner Registration", details: "Beverly Hills, California")
                HistoryEvent(date: "May 2023", event: "Dealer Service", details: "5,000 mile service completed")
                HistoryEvent(date: "December 2023", event: "Dealer Service", details: "12,000 mile service completed")
                HistoryEvent(date: "March 2024", event: "Listed for Auction", details: "Premium Auto Gallery")
            }
        }
    }
    
    // MARK: - Inspection Tab
    private var inspectionTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Professional Inspection")
                .font(.custom("Exo2-SemiBold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(spacing: 12) {
                InspectionCategory(title: "Exterior", rating: 9.5, details: "Excellent condition, minor paint chips")
                InspectionCategory(title: "Interior", rating: 9.8, details: "Like new, no wear visible")
                InspectionCategory(title: "Engine", rating: 9.9, details: "Perfect mechanical condition")
                InspectionCategory(title: "Transmission", rating: 9.7, details: "Smooth operation, no issues")
                InspectionCategory(title: "Electronics", rating: 9.8, details: "All systems functioning perfectly")
            }
            
            HStack {
                Text("Overall Rating:")
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Spacer()
                
                Text("9.7/10")
                    .font(.custom("Exo2-Bold", size: 18))
                    .foregroundColor(.green)
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Call Seller")
                    }
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.primaryColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.theme.primaryColor, lineWidth: 2)
                    )
                }
                
                Button(action: {
                    showBidSheet = true
                }) {
                    HStack {
                        Image(systemName: "hammer.fill")
                        Text("Place Bid")
                    }
                    .font(.custom("Exo2-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.theme.primaryColor)
                            .shadow(color: .theme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
        )
    }
    
    // MARK: - Helper Functions
    private func updateTimeRemaining() {
        let now = Date()
        timeRemaining = auctionEndDate.timeIntervalSince(now)
        
        if timeRemaining <= 0 {
            timeRemaining = 0
        }
    }
    
    private func countdownString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        if timeRemaining <= 0 {
            return "Closed"
        } else {
            return formatter.string(from: timeRemaining) ?? "Closed"
        }
    }
}

// MARK: - Supporting Views

struct SpecBadge: View {
    let icon: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.theme.primaryColor)
            
            Text(value)
                .font(.custom("Exo2-SemiBold", size: 14))
                .foregroundColor(.theme.onSurfaceColor)
            
            Text(unit)
                .font(.custom("Exo2-Regular", size: 10))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
        }
        .frame(minWidth: 60)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct BidRowView: View {
    let bidder: String
    let amount: Double
    let time: String
    let isHighest: Bool
    
    var body: some View {
        HStack {
            Text(bidder)
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(.theme.onSurfaceColor)
            
            Spacer()
            
            Text(String(format: "$%.0f", amount))
                .font(.custom("Exo2-SemiBold", size: 14))
                .foregroundColor(isHighest ? .theme.primaryColor : .theme.onSurfaceColor)
            
            Text(time)
                .font(.custom("Exo2-Regular", size: 12))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                .frame(width: 50, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(isSelected ? .theme.primaryColor : .theme.onSurfaceColor.opacity(0.6))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.theme.primaryColor.opacity(0.1) : .clear)
                )
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(.theme.onSurfaceColor)
        }
        .padding(.vertical, 8)
    }
}

struct FeatureGroup: View {
    let title: String
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            
            ForEach(features, id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 12))
                    
                    Text(feature)
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

struct HistoryEvent: View {
    let date: String
    let event: String
    let details: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.theme.primaryColor)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event)
                    .font(.custom("Exo2-SemiBold", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Text(details)
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                
                Text(date)
                    .font(.custom("Exo2-Regular", size: 10))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.5))
            }
        }
    }
}

struct InspectionCategory: View {
    let title: String
    let rating: Double
    let details: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Spacer()
                
                Text(String(format: "%.1f/10", rating))
                    .font(.custom("Exo2-SemiBold", size: 14))
                    .foregroundColor(rating > 9 ? .green : rating > 7 ? .orange : .red)
            }
            
            ProgressView(value: rating / 10)
                .progressViewStyle(LinearProgressViewStyle(tint: rating > 9 ? .green : rating > 7 ? .orange : .red))
            
            Text(details)
                .font(.custom("Exo2-Regular", size: 12))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Bid Sheet
struct BidSheetView: View {
    let currentBid: Double
    let onBidSubmitted: (Double) -> Void
    @State private var bidAmount = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Place Your Bid")
                        .font(.custom("Exo2-Bold", size: 24))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text("Current highest bid: $\(Int(currentBid))")
                        .font(.custom("Exo2-Regular", size: 16))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Bid Amount")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    HStack {
                        Text("$")
                            .font(.custom("Exo2-Regular", size: 18))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        TextField("Enter amount", text: $bidAmount)
                            .font(.custom("Exo2-Regular", size: 18))
                            .keyboardType(.numberPad)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.primaryColor.opacity(0.3), lineWidth: 1)
                    )
                }
                
                HStack(spacing: 12) {
                    ForEach([1000, 2500, 5000], id: \.self) { increment in
                        Button(action: {
                            let newBid = currentBid + Double(increment)
                            bidAmount = String(format: "%.0f", newBid)
                        }) {
                            Text("+$\(increment)")
                                .font(.custom("Exo2-Medium", size: 14))
                                .foregroundColor(.theme.primaryColor)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.theme.primaryColor, lineWidth: 1)
                                )
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if let amount = Double(bidAmount) {
                        onBidSubmitted(amount)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Submit Bid")
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.primaryColor)
                        )
                }
                .disabled(bidAmount.isEmpty)
            }
            .background(Color.theme.surfaceColor)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        
    }
}

#Preview {
    AuctionCarDetailView()
}
