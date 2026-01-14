//
//  LiveAuctionsScreen.swift
//  TorqueNet
//
//  Created by MAC on 16/09/2025.
//

import SwiftUI

struct LiveAuctionsView: View {
    @EnvironmentObject var router: Router
    @StateObject var liveAuctionViewModel =  LiveAuctionViewModel()
    
    let categories = ["All", "Ongoing", "Closed"]
    
    var filteredAuctions: [AuctionUploadModel] {
        let categoryFiltered = liveAuctionViewModel.liveAuctionUiState.selectedCategory == "All" ? liveAuctionViewModel.liveAuctionUiState.fetchedAuctions : liveAuctionViewModel.liveAuctionUiState.fetchedAuctions.filter { $0.auctionStatus == liveAuctionViewModel.liveAuctionUiState.selectedCategory}
        
        if liveAuctionViewModel.liveAuctionUiState.searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { $0.carTitle.localizedCaseInsensitiveContains(liveAuctionViewModel.liveAuctionUiState.searchText) }
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(), value: true)
                    
                    Text("\(filteredAuctions.count) ongoing auctions")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
                // Search bar
                searchBar
                
                // Category filter
                categoryFilter
                
                // Live auctions grid
                if filteredAuctions.isEmpty {
                    EmptyStateView(
                        imageName: "empty_recent",
                        title: "No Live Auction",
                        subtitle: "Check back later for featured auctions",
                        height: 160
                    )
                    .padding(.horizontal, 16)
                } else {
                    auctionsGrid
                }
                
            }
           
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Live Auctions",
            leadingIcon: "chevron.left",
            navbarTitleDisplayMode: .inline,
            onLeadingTap: {
                router.pop()
            },
            trailingIcon: "arrow.clockwise",
            onTrailingTap: {
                liveAuctionViewModel.refreshAuctions()
            },
            trailingMenu: {}
            )
        .toastView(toast: $liveAuctionViewModel.liveAuctionUiState.toast)
        .fullScreenProgressOverlay(isShowing: liveAuctionViewModel.liveAuctionUiState.auctionState == .isLoading)
        .task {
            await liveAuctionViewModel.fetchAuctions(
                onSuccess: {},
                onFailure: { _ in }
            )
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search live auctions...", text: Binding(
                get: { liveAuctionViewModel.liveAuctionUiState.searchText },
                set: { liveAuctionViewModel.updateSaerchText($0) }
            ))
                .font(.custom("Exo2-Regular", size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.theme.surfaceColor)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    LiveCategoryChip(
                        title: category,
                        isSelected: liveAuctionViewModel.liveAuctionUiState.selectedCategory == category
                    ) {
                        liveAuctionViewModel.updateSelectedCategory(category)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var auctionsGrid: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(filteredAuctions) { auction in
                    LiveAuctionCard2(
                        auction:auction
                    ) {
                        liveAuctionViewModel.openAuctionDetail(auction)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .refreshable {
            await liveAuctionViewModel.refreshAuctionsAsync()
        }
    }
}

struct LiveCategoryChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(isSelected ? .white : .theme.onSurfaceColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.theme.primaryColor : Color.theme.surfaceColor)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LiveAuctionCard2: View {
    let auction:AuctionUploadModel
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                CustomImageView(url:auction.imageUrls.last ?? "", maxWidth: 170, height: 120,)
                    .frame(width: 170, height: 120)
                    .cornerRadius(12)
                
                // Live pulse animation
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 6, height: 6)
                        .scaleEffect(1.2)
                    
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
                    Text(auction.currentBid.description)
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.primaryColor)
                    
                    Spacer()
                    
                    Text("\(auction.bidCount) bids")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.all,12)
        .frame(width: 200)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    NavigationView{
        LiveAuctionsView()
    }
    
}

