//
//  AuctionCarDetailView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 11/09/2025.
//

import SwiftUI

struct AuctionCarDetailView: View {
    @EnvironmentObject var router: Router
    @StateObject var auctionDetailViewModel = AuctionDetailsViewModel()
    @EnvironmentObject var settingsViewModel : SettingsViewModel
    let auctionId:String
    
    @State var auction:AuctionUploadModel? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    imageGallerySection
                    
                    VStack(spacing: 24) {
                        carTitleSection
                        
                        auctionInfoSection
                        
                        tabSection
                        
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
            if auctionDetailViewModel.auctionDetailsUiState.timeRemaining > 0 {
                VStack {
                    Spacer()
                    bottomActionBar
                }
                .padding(.horizontal, 20)
            } else if settingsViewModel.currentUser?.isSeller ?? false{
                VStack {
                    Spacer()
                    auctionExpiredManagementBar
                }
                .padding(.horizontal, 20)
               
            } else {
                VStack{
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auction Ended")
                                .font(.custom("Exo2-SemiBold", size: 16))
                                .foregroundColor(.theme.onSurfaceColor)
                            
                            Text("Please Check on other auctions")
                                .font(.custom("Exo2-Regular", size: 12))
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.4))
                    )
                }
                .padding(.horizontal,20)
            }
          
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.theme.surfaceColor)
        .padding(.horizontal, 20)
        .onAppear {
            updateTimeRemaining()
            Task{
                await auctionDetailViewModel.fetchAuction(
                    auctionId: auctionId,
                    onSuccess: {auction = auctionDetailViewModel.auctionDetailsUiState.fetchedAuction},
                    onFailure: {_ in})
                await auctionDetailViewModel.fetchBids(
                    auctionId:auctionId,
                    onSuccess: {},
                    onFailure: {_ in})
            }
        }
        .fullScreenProgressOverlay(isShowing: auctionDetailViewModel.auctionDetailsUiState.auctionState == .isLoading)
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
        .toastView(toast: $auctionDetailViewModel.auctionDetailsUiState.toast)
        .sheet(isPresented: $auctionDetailViewModel.auctionDetailsUiState.showBidSheet) {
            BidSheetView(
                currentBid: auction?.currentBid ?? 0,
                auctionDetailsUiState: $auctionDetailViewModel.auctionDetailsUiState,
                onBidSubmitted: { amount in
                    Task{
                        await auctionDetailViewModel.placeBid(
                            bidUser: settingsViewModel.currentUser?.name ?? "",
                            onSuccess: {
                                auctionDetailViewModel.auctionDetailsUiState.toast = Toast(style: .success, message: "Bid placed successfully")
                            },
                            onFailure: {error in
                                auctionDetailViewModel.auctionDetailsUiState.toast = Toast(style: .error, message: error)
                            }
                        )
                    }
                })
            }
        .sheet(isPresented: $auctionDetailViewModel.auctionDetailsUiState.showStatusManagementSheet) {
            AuctionStatusManagementSheet(
                auctionDetailsUiState: $auctionDetailViewModel.auctionDetailsUiState,
                onStatusUpdated: { newStatus, newEndTime in
                    Task {
                        await auctionDetailViewModel.updateAuctionStatus(
                            auctionId: auctionId,
                            newStatus: newStatus,
                            newEndTime: newEndTime,
                            onSuccess: {
                                auctionDetailViewModel.auctionDetailsUiState.toast = Toast(style: .success, message: "Auction status updated successfully")
                                Task {
                                    await auctionDetailViewModel.fetchAuction(
                                        auctionId: auctionId,
                                        onSuccess: {auction = auctionDetailViewModel.auctionDetailsUiState.fetchedAuction},
                                        onFailure: {_ in})
                                }
                            },
                            onFailure: { error in
                                auctionDetailViewModel.auctionDetailsUiState.toast = Toast(style: .error, message: error)
                            }
                        )
                    }
                }
            )
        }
    }
    
    private var imageGallerySection: some View {
        ZStack {
            TabView(selection: $auctionDetailViewModel.auctionDetailsUiState.selectedImageIndex) {
                if let auction = auction{
                    ForEach(Array(auction.imageUrls.enumerated()), id: \.offset) { index, imageUrl in
                        ZStack {
                            CustomImageView(
                                url: imageUrl,
                                maxWidth: .infinity,
                                height: .infinity
                            )
                            .ignoresSafeArea(edges: .top)
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
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 450)
            .ignoresSafeArea(edges: .top)
            
            
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
                                auctionDetailViewModel.auctionDetailsUiState.isFavorite.toggle()
                            }
                        }) {
                            Image(systemName: auctionDetailViewModel.auctionDetailsUiState.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(auctionDetailViewModel.auctionDetailsUiState.isFavorite ? .red : .white)
                                .frame(width: 44, height: 44)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .scaleEffect(auctionDetailViewModel.auctionDetailsUiState.isFavorite ? 1.1 : 1.0)
                        
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
                
                HStack(spacing: 8) {
                    if let auction = auction {
                        ForEach(auction.imageUrls.indices, id: \.self) { index in
                            Circle()
                                .fill(
                                    auctionDetailViewModel.auctionDetailsUiState.selectedImageIndex == index
                                    ? Color.white
                                    : Color.white.opacity(0.5)
                                )
                                .frame(width: 8, height: 8)
                                .scaleEffect(
                                    auctionDetailViewModel.auctionDetailsUiState.selectedImageIndex == index
                                    ? 1.2
                                    : 1.0
                                )
                                .animation(
                                    .spring(),
                                    value: auctionDetailViewModel.auctionDetailsUiState.selectedImageIndex
                                )
                        }
                    }
                    
                }
                .padding(.bottom, 20)
            }
            .padding()
            .padding(.vertical, 32)
        }
    }
    
    private var carTitleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(auction?.carTitle ?? "")
                        .font(.custom("Exo2-Bold", size: 28))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text(auction?.subtitle ?? "")
                        .font(.custom("Exo2-Medium", size: 16))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Lot #\(auction?.lotNumber)")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text("\(auction?.rating ?? 0.0, specifier: "%.1f")")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                }
            }
            
            // Key Specs
            HStack(spacing: 20) {
                if let auction = auction {
                    SpecBadge(icon: "speedometer", value: auction.mileage, unit: "miles")
                    SpecBadge(icon: "calendar", value: auction.year, unit: "year")
                    SpecBadge(icon: "fuelpump.fill", value: auction.engine, unit: "engine")
                    SpecBadge(icon: "gearshape.fill", value: auction.transmission, unit: "trans")
                }
                
            }
        }
        .padding(.horizontal,8)
        
        
    }
    
    private var auctionInfoSection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Bid")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text(auction?.currentBid.description ?? "")
                        .font(.custom("Exo2-Bold", size: 32))
                        .foregroundColor(.theme.primaryColor)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(.green)
                            .font(.system(size: 12))
                        Text("\(auction?.bidCount) bids")
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
                        .foregroundColor(auctionDetailViewModel.auctionDetailsUiState.timeRemaining > 3600 ? .green : .orange)
                    
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
    
    private var bidHistoryPreview: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Recent Bids")
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)

            if auctionDetailViewModel.sortedBids.isEmpty {
                Text("No bids yet")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.gray)
            } else {
                VStack(spacing: 8) {
                    ForEach(auctionDetailViewModel.sortedBids.prefix(3)) { bid in
                        BidRowView(
                            bidder: Utils.shared.maskedUser(bid.bidUser),
                            amount: bid.bidAmount,
                            time: Utils.shared.formatDateToHumanReadable(bid.bidTime.dateValue().description),
                            isHighest: bid.bidAmount == auctionDetailViewModel.highestBidAmount
                        )
                    }
                }
            }

            Button(action: {
                // Navigate to full bids screen / sheet
                //auctionDetailsUiState.showBidSheet = true
            }) {
                Text("View All Bids")
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.primaryColor)
            }
        }
    }

    
    private var tabSection: some View {
        HStack {
            TabButton(title: "Details", isSelected: auctionDetailViewModel.auctionDetailsUiState.selectedTab == 0) {
                auctionDetailViewModel.auctionDetailsUiState.selectedTab = 0
            }
            TabButton(title: "Features", isSelected: auctionDetailViewModel.auctionDetailsUiState.selectedTab == 1) {
                auctionDetailViewModel.auctionDetailsUiState.selectedTab = 1
            }
            TabButton(title: "History", isSelected: auctionDetailViewModel.auctionDetailsUiState.selectedTab == 2) {
                auctionDetailViewModel.auctionDetailsUiState.selectedTab = 2
            }
            TabButton(title: "Inspection", isSelected: auctionDetailViewModel.auctionDetailsUiState.selectedTab == 3) {
                auctionDetailViewModel.auctionDetailsUiState.selectedTab = 3
            }
        }
    }
    
    private var tabContentSection: some View {
        Group {
            switch auctionDetailViewModel.auctionDetailsUiState.selectedTab {
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
    
    private var detailsTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let auction = auction {
                DetailRow(label: "Make", value: auction.make)
                DetailRow(label: "Model", value: auction.model)
                DetailRow(label: "Year", value: auction.year)
                DetailRow(label: "Mileage", value: "\(auction.mileage) miles")
                DetailRow(label: "Engine", value: auction.engine)
                DetailRow(label: "Transmission", value: auction.transmission)
                DetailRow(label: "Drivetrain", value: auction.drivetrain)
                DetailRow(label: "Exterior Color", value: auction.exteriorColor)
                DetailRow(label: "Interior Color", value: auction.interiorColor)
                DetailRow(label: "VIN", value: auction.vin)
                DetailRow(label: "Location", value: auction.location)
                DetailRow(label: "Seller", value: auction.seller)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var featuresTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let auction = auction {
                FeatureGroup(title: "Performance", features: auction.performanceFeatures)
                FeatureGroup(title: "Technology", features:auction.technologyFeatures)
                FeatureGroup(title: "Comfort & Convenience", features: auction.comfortFeatures)
            }
        }
        
    }
    
    private var historyTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vehicle History")
                .font(.custom("Exo2-SemiBold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(spacing: 12) {
                if let auction = auction {
                    ForEach(auction.historyEvents, id: \.date) { historyEvents in
                        HistoryEvent(date: historyEvents.date, event: historyEvents.event, details: historyEvents.details)
                    }
                }
            }
        }
    }
    
    private var inspectionTabContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Professional Inspection")
                .font(.custom("Exo2-SemiBold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(spacing: 12) {
                if let auction = auction {
                    InspectionCategory(title: "Exterior", rating: auction.inspection.exterior.rating, details: auction.inspection.exterior.details)
                    InspectionCategory(title: "Interior",rating: auction.inspection.interior.rating, details: auction.inspection.interior.details)
                    InspectionCategory(title: "Engine", rating: auction.inspection.engine.rating, details: auction.inspection.engine.details)
                    InspectionCategory(title: "Transmission", rating: auction.inspection.transmission.rating, details: auction.inspection.transmission.details)
                    InspectionCategory(title: "Electronics", rating: auction.inspection.electronics.rating, details: auction.inspection.electronics.details)
                }
                
            }
            
            HStack {
                Text("Overall Rating:")
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Spacer()
                
                Text("\(auction?.rating.rounded())/10")
                    .font(.custom("Exo2-Bold", size: 18))
                    .foregroundColor(.green)
            }
            .padding(.top, 8)
        }
        .padding()
    }
    
    
    
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
                    auctionDetailViewModel.auctionDetailsUiState.showBidSheet = true
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
    
    private var auctionExpiredManagementBar: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Auction Ended")
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text("Manage auction status and timing")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange.opacity(0.1))
            )
            
            Button(action: {
                auctionDetailViewModel.auctionDetailsUiState.showStatusManagementSheet = true
            }) {
                HStack {
                    Image(systemName: "gearshape.fill")
                    Text("Manage Auction Status")
                }
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.primaryColor)
                        .shadow(color: .theme.primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                )
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
    
    private func updateTimeRemaining() {
        if let auction = auction {
            let now = Date()
            auctionDetailViewModel.auctionDetailsUiState.timeRemaining  = auction.auctionEndDate.dateValue().timeIntervalSince(now)
            
            if auctionDetailViewModel.auctionDetailsUiState.timeRemaining  <= 0 {
                auctionDetailViewModel.auctionDetailsUiState.timeRemaining  = 0
            }
        }
        
    }
    
    private func countdownString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        if auctionDetailViewModel.auctionDetailsUiState.timeRemaining  <= 0 {
            return "Closed"
        } else {
            return formatter.string(from: auctionDetailViewModel.auctionDetailsUiState.timeRemaining ) ?? "Closed"
        }
    }
}


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
            VStack(alignment: .leading, spacing: 4) {
                Text(bidder)
                    .font(.custom("Exo2-Medium", size: 14))

                Text(time)
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("KES \(Int(amount))")
                .font(.custom("Exo2-SemiBold", size: 14))
                .foregroundColor(isHighest ? .green : .theme.onSurfaceColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isHighest ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
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

struct BidSheetView: View {
    let currentBid: Double
    @Binding var auctionDetailsUiState:AuctionDetailUiState
    let onBidSubmitted: (Double) -> Void
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
                    
                    TextField("Enter amount", text: $auctionDetailsUiState.bidAmount)
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
                        auctionDetailsUiState.bidAmount = String(format: "%.0f", newBid)
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
                if let amount = Double(auctionDetailsUiState.bidAmount) {
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
            .disabled(auctionDetailsUiState.bidAmount.isEmpty)
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

struct AuctionStatusManagementSheet: View {
    @Binding var auctionDetailsUiState: AuctionDetailUiState
    let onStatusUpdated: (String, Date?) -> Void
    @Environment(\.presentationMode) var presentationMode
    
  
    
    var calculatedEndDate: Date {
        if auctionDetailsUiState.useCustomDate {
            return auctionDetailsUiState.customDate
        } else {
            return Date().addingTimeInterval(TimeInterval(auctionDetailsUiState.selectedHours * 3600))
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "gearshape.2.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.theme.primaryColor)
                        
                        Text("Manage Auction Status")
                            .font(.custom("Exo2-Bold", size: 24))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Text("Update the auction status and adjust timing")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Auction Status")
                            .font(.custom("Exo2-SemiBold", size: 16))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        VStack(spacing: 12) {
                            ForEach(auctionDetailsUiState.statusOptions, id: \.self) { status in
                                StatusOptionButton(
                                    status: status,
                                    isSelected: auctionDetailsUiState.selectedStatus == status,
                                    action: { auctionDetailsUiState.selectedStatus = status }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if auctionDetailsUiState.selectedStatus == "Ongoing" {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Extend Auction Time")
                                .font(.custom("Exo2-SemiBold", size: 16))
                                .foregroundColor(.theme.onSurfaceColor)
                            
                            if !auctionDetailsUiState.useCustomDate {
                                VStack(spacing: 12) {
                                    Text("Select duration to extend:")
                                        .font(.custom("Exo2-Regular", size: 14))
                                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ForEach(auctionDetailsUiState.hourOptions, id: \.self) { hours in
                                            HourOptionButton(
                                                hours: hours,
                                                isSelected: auctionDetailsUiState.selectedHours == hours,
                                                action: { auctionDetailsUiState.selectedHours = hours }
                                            )
                                        }
                                    }
                                }
                                
                                Button(action: {
                                    auctionDetailsUiState.useCustomDate = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                        Text("Set Custom End Date")
                                    }
                                    .font(.custom("Exo2-Medium", size: 14))
                                    .foregroundColor(.theme.primaryColor)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.theme.primaryColor, lineWidth: 1)
                                    )
                                }
                                .padding(.top, 8)
                            }
                            
                            if auctionDetailsUiState.useCustomDate {
                                VStack(spacing: 12) {
                                    DatePicker(
                                        "End Date & Time",
                                        selection: $auctionDetailsUiState.customDate,
                                        in: Date()...,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .datePickerStyle(.graphical)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.theme.surfaceColor)
                                    )
                                    
                                    Button(action: {
                                        auctionDetailsUiState.useCustomDate = false
                                    }) {
                                        HStack {
                                            Image(systemName: "clock")
                                            Text("Use Quick Selection")
                                        }
                                        .font(.custom("Exo2-Medium", size: 14))
                                        .foregroundColor(.theme.primaryColor)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.theme.primaryColor, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("New End Time:")
                                        .font(.custom("Exo2-Regular", size: 12))
                                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                                    
                                    Text(Utils.shared.formatDate(calculatedEndDate))
                                        .font(.custom("Exo2-SemiBold", size: 14))
                                        .foregroundColor(.theme.primaryColor)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.primaryColor.opacity(0.1))
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let endTime = auctionDetailsUiState.selectedStatus == "Ongoing" ? calculatedEndDate : nil
                        onStatusUpdated(auctionDetailsUiState.selectedStatus, endTime)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.custom("Exo2-SemiBold", size: 16))
                    .foregroundColor(.theme.primaryColor)
                }
            }
        }
    }
}

struct StatusOptionButton: View {
    let status: String
    let isSelected: Bool
    let action: () -> Void
    
    var statusInfo: (icon: String, title: String, description: String, color: Color) {
        switch status {
        case "live":
            return ("antenna.radiowaves.left.and.right", "Live", "Auction is active and accepting bids", .green)
        case "closed":
            return ("xmark.circle", "Closed", "Auction has ended, no more bids", .orange)
        case "sold":
            return ("checkmark.circle", "Sold", "Vehicle has been sold", .blue)
        default:
            return ("questionmark.circle", status, "", .gray)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: statusInfo.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : statusInfo.color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(statusInfo.title)
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(isSelected ? .white : .theme.onSurfaceColor)
                    
                    Text(statusInfo.description)
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .theme.onSurfaceColor.opacity(0.6))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? statusInfo.color : Color.theme.surfaceColor)
                    .shadow(color: isSelected ? statusInfo.color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : statusInfo.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HourOptionButton: View {
    let hours: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(hours)")
                    .font(.custom("Exo2-Bold", size: 20))
                    .foregroundColor(isSelected ? .white : .theme.primaryColor)
                
                Text(hours == 1 ? "hour" : "hours")
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .theme.onSurfaceColor.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.theme.primaryColor : Color.theme.surfaceColor)
                    .shadow(color: isSelected ? Color.theme.primaryColor.opacity(0.3) : .clear, radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.theme.primaryColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AuctionCarDetailView(
        auctionId:""
    )
}
