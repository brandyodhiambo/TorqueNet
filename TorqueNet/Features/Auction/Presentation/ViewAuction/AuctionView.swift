//
//  AuctionView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//


import SwiftUI


struct AuctionView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @StateObject var viewAuctionViewModel = ViewAuctionViewModel()
    
    let categories = ["All", "Upcoming", "Ongoing", "Completed", "Featured"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Search Bar
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            
                            TextField(
                                "Search auctions...",
                                text: Binding(
                                    get: { viewAuctionViewModel.viewAuctionUiState.searchText },
                                    set: { viewAuctionViewModel.updateSaerchText($0) }
                                )
                            )
                            .font(.custom("Exo2-Regular", size: 16))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        Button(action: {
                            // Filter action
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.theme.primaryColor)
                                .padding(12)
                                .background(Color.theme.primaryColor.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                                Button(action: {
                                    viewAuctionViewModel.updateSelectedCategory(index)
                                }) {
                                    Text(category)
                                        .font(.custom("Exo2-Medium", size: 14))
                                        .foregroundColor(
                                            viewAuctionViewModel.viewAuctionUiState.selectedCategory == index
                                                ? .white
                                                : .theme.onSurfaceColor
                                        )
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewAuctionViewModel.viewAuctionUiState.selectedCategory == index
                                                ? Color.theme.primaryColor
                                                : Color.gray.opacity(0.1)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Error State
                    if case .error(let message) = viewAuctionViewModel.viewAuctionUiState.auctionState {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.red.opacity(0.6))
                            Text("Failed to Load Auctions")
                                .font(.custom("Exo2-Bold", size: 18))
                                .foregroundColor(.theme.onSurfaceColor)
                            Text(message)
                                .font(.custom("Exo2-Regular", size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            Button("Retry") {
                                Task {
                                    await viewAuctionViewModel.fetchAuctions(
                                        onSuccess: {},
                                        onFailure: { _ in }
                                    )
                                }
                            }
                            .font(.custom("Exo2-Bold", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.theme.primaryColor)
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    }
                    else if case .good = viewAuctionViewModel.viewAuctionUiState.auctionState {
                        if viewAuctionViewModel.viewAuctionUiState.isShowingAllCategories {
                            AllCategoriesView(viewModel: viewAuctionViewModel, router: router)
                        } else {
                            FilteredCategoryView(viewModel: viewAuctionViewModel, router: router)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color.theme.surfaceColor)
            .customTopAppBar(
                title: "Auctions",
                leadingIcon: "",
                navbarTitleDisplayMode: .automatic,
                onLeadingTap: {},
                onTrailingTap: {},
                trailingMenu: {
                    if settingsViewModel.currentUser?.isSeller ?? false {
                        Menu {
                            Button("Upload Auction") {
                                router.push(.auctionUpload)
                            }
                            Button("Upload Car") {
                                router.push(.uploadCar)
                            }
                        } label: {
                            Label("Menu", systemImage: "plus")
                        }
                    }
                }
            )
        }
        .fullScreenProgressOverlay(isShowing: viewAuctionViewModel.viewAuctionUiState.auctionState == .isLoading)
        .task {
            await viewAuctionViewModel.fetchAuctions(
                onSuccess: {},
                onFailure: { _ in }
            )
        }
    }
}

struct AllCategoriesView: View {
    @ObservedObject var viewModel: ViewAuctionViewModel
    var router: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !viewModel.viewAuctionUiState.featuredAuctions.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Featured Auctions")
                                .font(.custom("Exo2-Bold", size: 20))
                                .foregroundColor(.theme.onSurfaceColor)
                            
                            Text("Premium vehicles ending soon")
                                .font(.custom("Exo2-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.viewAuctionUiState.featuredAuctions) { auction in
                                FeaturedAuctionCard(auction: auction) {
                                    router.push(.auctionDetails(auction: auction))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            } else {
                EmptyStateView(
                    imageName: "empty_recent",
                    title: "No Featured Auction",
                    subtitle: "Check back later for featured auctions",
                    height: 160
                )
                .padding(.horizontal, 16)
            }
            
            // Live Auctions
            if !viewModel.viewAuctionUiState.liveAuctions.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            
                            Text("Live Auctions")
                                .font(.custom("Exo2-Bold", size: 20))
                                .foregroundColor(.theme.onSurfaceColor)
                        }
                        
                        Spacer()
                        
                        Button("View All") {
                            router.push(.auctionLiveBids)
                        }
                        .font(.custom("Exo2-Medium", size: 14))
                        .foregroundColor(.theme.primaryColor)
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.viewAuctionUiState.liveAuctions) { auction in
                                LiveAuctionCard(auction: auction) {
                                    router.push(.auctionDetails(auction: auction))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            } else {
                EmptyStateView(
                    imageName: "empty_recent",
                    title: "No Live Auction",
                    subtitle: "Check back later for live auctions",
                    height: 160
                )
                .padding(.horizontal, 16)
            }
            
            // Upcoming Auctions
            if !viewModel.viewAuctionUiState.upcomingAuctions.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Upcoming This Week")
                                .font(.custom("Exo2-Bold", size: 20))
                                .foregroundColor(.theme.onSurfaceColor)
                            
                            Text("Set reminders for these auctions")
                                .font(.custom("Exo2-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button("Calendar") {
                            // Calendar action
                        }
                        .font(.custom("Exo2-Medium", size: 14))
                        .foregroundColor(.theme.primaryColor)
                    }
                    .padding(.horizontal, 16)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.viewAuctionUiState.upcomingAuctions.prefix(5)) { auction in
                            UpcomingAuctionRow(auction: auction) {
                                router.push(.auctionDetails(auction: auction))
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            } else {
                EmptyStateView(
                    imageName: "empty_recent",
                    title: "No Upcoming Auction",
                    subtitle: "Check back later for upcoming auctions",
                    height: 160
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

struct FilteredCategoryView: View {
    @ObservedObject var viewModel: ViewAuctionViewModel
    var router: Router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.viewAuctionUiState.filteredAuctions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.4))
                    Text("No Auctions Found")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.onSurfaceColor)
                    Text("Try adjusting your filters or search terms")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 100)
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(getCategoryTitle())
                            .font(.custom("Exo2-Bold", size: 20))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Text("\(viewModel.viewAuctionUiState.filteredAuctions.count) auctions found")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.viewAuctionUiState.filteredAuctions) { auction in
                        FilteredAuctionCard(auction: auction) {
                            router.push(.auctionDetails(auction: auction))
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    private func getCategoryTitle() -> String {
        let categories = ["All", "Upcoming", "Ongoing", "Completed", "Featured"]
        return "\(categories[viewModel.viewAuctionUiState.selectedCategory]) Auctions"
    }
}

struct FilteredAuctionCard: View {
    let auction: AuctionUploadModel
    let onTap: () -> Void
    @State private var timeRemaining: TimeInterval
    
    init(auction: AuctionUploadModel, onTap: @escaping () -> Void) {
        self.auction = auction
        self.onTap = onTap
        self._timeRemaining = State(initialValue: auction.auctionEndDate.dateValue().timeIntervalSinceNow)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            ZStack(alignment: .topLeading) {
                CustomImageView(url: auction.imageUrls.first ?? "", maxWidth: 140, height: 120)
                    .cornerRadius(12)
                
                // Status badge
                if auction.auctionStatus == "Ongoing" {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.custom("Exo2-Bold", size: 8))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(8)
                } else if auction.auctionStatus == "Featured" {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.yellow)
                        Text("FEATURED")
                            .font(.custom("Exo2-Bold", size: 8))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.orange)
                    .cornerRadius(8)
                    .padding(8)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(auction.carTitle)
                    .font(.custom("Exo2-Bold", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text(auction.auctionStatus == "Upcoming" ? "Starts Soon" : "Ends in \(formatTimeRemaining())")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(auction.auctionStatus == "Upcoming" ? "Starting Bid" : "Current Bid")
                        .font(.custom("Exo2-Regular", size: 11))
                        .foregroundColor(.gray)
                    
                    Text("$\(Int(auction.currentBid ?? auction.startingBid))")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.primaryColor)
                }
                
                HStack {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.theme.primaryColor)
                        .font(.system(size: 10))
                    
                    Text("\(auction.bidCount ?? 0) bids")
                        .font(.custom("Exo2-Medium", size: 11))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(auction.auctionStatus == "Upcoming" ? "Notify" : "Bid Now") {
                        onTap()
                    }
                    .font(.custom("Exo2-Bold", size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.theme.primaryColor)
                    .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.theme.surfaceColor)
        .cornerRadius(12)
        .shadow(color: Color.theme.onSurfaceColor.opacity(0.08), radius: 8, x: 0, y: 2)
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
    
    private func formatTimeRemaining() -> String {
        let totalSeconds = Int(max(0, timeRemaining))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(totalSeconds)s"
        }
    }
}

struct FeaturedAuctionCard: View {
    let auction: AuctionUploadModel
    let onTap: () -> Void
    @State private var timeRemaining: TimeInterval
    
    init(auction: AuctionUploadModel, onTap: @escaping () -> Void) {
        self.auction = auction
        self.onTap = onTap
        self._timeRemaining = State(initialValue: auction.auctionEndDate.dateValue().timeIntervalSinceNow)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                CustomImageView(url: auction.imageUrls.first ?? "", maxWidth: 300, height: 300,)
                .clipped()
                .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                
                // Live badge
                if auction.auctionStatus == "Ongoing" {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.custom("Exo2-Bold", size: 10))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .padding(12)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 2) {
                            Text("ENDS IN")
                                .font(.custom("Exo2-Bold", size: 8))
                                .foregroundColor(.white.opacity(0.8))
                            Text(formatTimeRemaining())
                                .font(.custom("Exo2-Bold", size: 12))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        .padding(12)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(auction.carTitle)
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .lineLimit(2)
                    
                    Text("Good Condition")
                        .font(.custom("Exo2-Medium", size: 12))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Bid")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.gray)
                        Text("$\(Int(auction.currentBid ?? auction.startingBid))")
                            .font(.custom("Exo2-Bold", size: 18))
                            .foregroundColor(.theme.primaryColor)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Starting Bid")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.gray)
                        Text("$\(Int(auction.startingBid))")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.theme.primaryColor)
                        .font(.system(size: 12))
                    Text("\(auction.bidCount ?? 0) bids")
                        .font(.custom("Exo2-Medium", size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Place Bid") {
                        onTap()
                    }
                    .font(.custom("Exo2-Bold", size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.theme.primaryColor)
                    .cornerRadius(16)
                }
            }
            .padding(16)
        }
        .frame(width: 300)
        .background(Color.theme.surfaceColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.onSurfaceColor.opacity(0.08), radius: 12, x: 0, y: 4)
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
    
    private func formatTimeRemaining() -> String {
        let totalSeconds = Int(max(0, timeRemaining))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes < 60{
            return "\(minutes)m"
        } else {
            return "\(Int(timeRemaining))s"
        }
    }
}

struct LiveAuctionCard: View {
    let auction: AuctionUploadModel
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                CustomImageView(url: auction.imageUrls.first ?? "", maxWidth: 200, height: 120,)
                .cornerRadius(12)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 6, height: 6)
                    Text("LIVE")
                        .font(.custom("Exo2-Bold", size: 8))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.red)
                .cornerRadius(8)
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(auction.carTitle)
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(Int(auction.currentBid ?? auction.startingBid))")
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.primaryColor)
                    
                    Spacer()
                    
                    Text("\(auction.bidCount ?? 0) bids")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 200)
        .onTapGesture {
            onTap()
        }
    }
}

struct UpcomingAuctionRow: View {
    let auction: AuctionUploadModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            CustomImageView(url: auction.imageUrls.first ?? "", maxWidth: 80, height: 60,)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(auction.carTitle)
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(1)
                
//                if let startDate = auction.auctionEndDate {
//                    Text("Starts \(Utils.shared.formatStartDate(Utils.shared.dateFromFirestoreTimestamp(startDate)))")
//                        .font(.custom("Exo2-Regular", size: 12))
//                        .foregroundColor(.gray)
//                } else {
//                    Text("Start date TBA")
//                        .font(.custom("Exo2-Regular", size: 12))
//                        .foregroundColor(.gray)
//                }
                
                Text("Starting at $\(Int(auction.startingBid))")
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.theme.primaryColor)
            }
            
            Spacer()
            
            Button(action: {
                // Set reminder
            }) {
                Image(systemName: "bell")
                    .font(.system(size: 16))
                    .foregroundColor(.theme.primaryColor)
                    .padding(8)
                    .background(Color.theme.primaryColor.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.theme.surfaceColor)
        .cornerRadius(12)
        .shadow(color: Color.theme.onSurfaceColor.opacity(0.05), radius: 8, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }

}

#Preview {
    NavigationView{
        AuctionView()
    }
    
}
