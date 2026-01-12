//
//  LiveAuctionsScreen.swift
//  TorqueNet
//
//  Created by MAC on 16/09/2025.
//

import SwiftUI

struct LiveAuctionsView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var liveAuctions: [LiveAuction] = sampleLiveAuctions
    @EnvironmentObject var router: Router
    @State var toast: Toast? = nil
    
    let categories = ["All", "Running", "Closed"]
    
    var filteredAuctions: [LiveAuction] {
        let categoryFiltered = selectedCategory == "All" ? liveAuctions : liveAuctions.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
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
                auctionsGrid
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
                refreshAuctions()
                //toast = Toast(style: .success, message: "Hurray! Auctions refreshed!")
            },
            trailingMenu: {}
            )
        .toastView(toast: $toast)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search live auctions...", text: $searchText)
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
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
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
                        imageName: auction.imageName,
                        title: auction.title
                    ) {
                        openAuctionDetail(auction)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .refreshable {
            await refreshAuctionsAsync()
        }
    }
    
    private func refreshAuctions() {
        withAnimation(.easeInOut(duration: 0.3)) {
            liveAuctions = sampleLiveAuctions.shuffled()
        }
    }
    
    private func refreshAuctionsAsync() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            refreshAuctions()
        }
    }
    
    private func openAuctionDetail(_ auction: LiveAuction) {
        print("Opening auction: \(auction.title)")
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
    let imageName: String
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
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
                Text(title)
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(2)
                
                HStack {
                    Text("$45,200")
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.primaryColor)
                    
                    Spacer()
                    
                    Text("23 bids")
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


// MARK: - Sample Data
let sampleLiveAuctions: [LiveAuction] = [
    LiveAuction(imageName: "car", title: "Vintage Rolex Submariner 1960s", category: "Collectibles", currentBid: 45200, bidCount: 23),
    LiveAuction(imageName: "car", title: "Abstract Canvas Oil Painting", category: "Art", currentBid: 12800, bidCount: 15),
    LiveAuction(imageName: "car", title: "1967 Ford Mustang Fastback", category: "Vehicles", currentBid: 89500, bidCount: 42),
    LiveAuction(imageName: "car", title: "2.5ct Diamond Engagement Ring", category: "Jewelry", currentBid: 28400, bidCount: 18),
    LiveAuction(imageName: "car", title: "iPhone 15 Pro Max 512GB", category: "Electronics", currentBid: 1200, bidCount: 8),
    LiveAuction(imageName: "car", title: "Bronze Sculpture Limited Edition", category: "Art", currentBid: 5600, bidCount: 11),
    LiveAuction(imageName: "car", title: "Ming Dynasty Porcelain Vase", category: "Collectibles", currentBid: 125000, bidCount: 67),
    LiveAuction(imageName: "car", title: "High-End Gaming PC Setup", category: "Electronics", currentBid: 3400, bidCount: 14)
]

