//
//  WishListView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct WishListView: View {
    @State var text: String = ""
    @State private var selectedCategory = 0
    @State private var showingDeleteAlert = false
    @EnvironmentObject var router: Router
    
    let wishListCars: [WishList] = [
        WishList(
            image: "car",
            title: "Red Mazda 6 - Elite Estate",
            currentPrice: 25000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 5)
        ),
        WishList(
            image: "car",
            title: "Blue BMW X5 - Premium Series",
            currentPrice: 45000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 8)
        ),
        WishList(
            image: "car",
            title: "Silver Tesla Model S - Luxury",
            currentPrice: 65000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 2)
        ),
    ]
    
    @State var carCategoryList = [
        CarCategory(id: 0, name: "All", icon: "square.grid.2x2", isSelected: true),
        CarCategory(id: 1, name: "Year", icon: "calendar", isSelected: false),
        CarCategory(id: 2, name: "Make", icon: "car.fill", isSelected: false),
        CarCategory(id: 3, name: "Model", icon: "list.bullet", isSelected: false),
        CarCategory(id: 4, name: "Location", icon: "location.fill", isSelected: false),
    ]
    
    private func selectCategory(withId id: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedCategory = id
            for index in carCategoryList.indices {
                carCategoryList[index].isSelected = (carCategoryList[index].id == id)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.theme.surfaceColor,
                        Color.theme.surfaceColor.opacity(0.95)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        // Header Section
                        headerSection
                        
                        // Categories Section
                        categoriesSection
                            .zIndex(1)
                        
                        // Cars Grid Section
                        carsSection
                            .zIndex(0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .customTopAppBar(
                title: "My Wishlist",
                leadingIcon: "",
                navbarTitleDisplayMode: .large,
                onLeadingTap: {},
                trailingIcon: "trash.fill",
                onTrailingTap: {
                    showingDeleteAlert = true
                }
            )
            .alert("Clear Wishlist", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    // Handle clear all action
                }
            } message: {
                Text("Are you sure you want to remove all items from your wishlist?")
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(wishListCars.count) Cars")
                        .font(.custom("Exo2-Bold", size: 28))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text("in your wishlist")
                        .font(.custom("Exo2-Regular", size: 16))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                }
                
                Spacer()
                
                // Stats card
                VStack {
                    Text("Total Value")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text("$\(Int(wishListCars.reduce(0) { $0 + $1.currentPrice }))K")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.primaryColor)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach($carCategoryList, id: \.self) { $category in
                    CategoryChip(
                        category: category,
                        isSelected: category.isSelected,
                        onTap: {
                            selectCategory(withId: category.id)
                        }
                    )
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    // MARK: - Cars Section
    private var carsSection: some View {
        LazyVStack(spacing: 20) {
            ForEach(Array(wishListCars.enumerated()), id: \.element.id) { index, wishListCar in
                WishListCarCard(
                    imageName: wishListCar.image,
                    title: wishListCar.title,
                    currentPrice: wishListCar.currentPrice,
                    auctionEndDate: wishListCar.auctionEndDate,
                    onFavoriteTapped: {
                        // Handle favorite toggle
                    },
                    onCardTapped: {
                        router.push(.auctionDetails)
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity).animation(.spring().delay(Double(index) * 0.1)),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
    }
}

// MARK: - Category Chip Component
struct CategoryChip: View {
    let category: CarCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(category.name)
                    .font(.custom("Exo2-Medium", size: 14))
            }
            .foregroundColor(isSelected ? .theme.onPrimaryColor : .theme.onSurfaceColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.theme.primaryColor : Color.gray.opacity(0.1))
                    .shadow(
                        color: isSelected ? .theme.primaryColor.opacity(0.3) : Color.theme.onSurfaceColor.opacity(0.05),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct WishListCarCard: View {
    var imageName: String
    var title: String
    var currentPrice: Double
    var auctionEndDate: Date
    var onFavoriteTapped: () -> Void
    var onCardTapped: () -> Void
    
    @State private var isFavorite = true
    @State private var timeRemaining: TimeInterval = 0
    @State private var isPressed = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: onCardTapped) {
            VStack(spacing: 0) {
                // Image Section
                ZStack {
                    // Main Image
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()
                    
                    // Gradient Overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .clear,
                            .black.opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Top Right Controls
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 8) {
                                // Favorite Button
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isFavorite.toggle()
                                        onFavoriteTapped()
                                    }
                                }) {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(isFavorite ? .red : .white)
                                        .frame(width: 40, height: 40)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                                .scaleEffect(isFavorite ? 1.1 : 1.0)
                                
                                // Share Button
                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(16)
                        
                        Spacer()
                    }
                    
                    // Auction Status Badge
                    VStack {
                        Spacer()
                        HStack {
                            auctionStatusBadge
                            Spacer()
                        }
                        .padding(16)
                    }
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(title)
                        .font(.custom("Exo2-SemiBold", size: 18))
                        .foregroundColor(.theme.onSurfaceColor)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Bid")
                                .font(.custom("Exo2-Regular", size: 12))
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                            
                            Text(String(format: "$%.0f", currentPrice))
                                .font(.custom("Exo2-Bold", size: 22))
                                .foregroundColor(.theme.primaryColor)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Time Left")
                                .font(.custom("Exo2-Regular", size: 12))
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                            
                            Text(countdownString())
                                .font(.custom("Exo2-Bold", size: 14))
                                .foregroundColor(timeRemaining > 3600 ? .green : timeRemaining > 0 ? .orange : .red)
                        }
                    }
                }
                .padding(20)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            updateTimeRemaining()
        }
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
    }
    private var auctionStatusBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(timeRemaining > 0 ? .green : .red)
                .frame(width: 8, height: 8)
            
            Text(timeRemaining > 0 ? "Live Auction" : "Auction Ended")
                .font(.custom("Exo2-Medium", size: 12))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
    
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

#Preview {
    WishListView()
}
