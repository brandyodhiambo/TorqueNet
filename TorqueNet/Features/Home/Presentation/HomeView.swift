//
//  HomeView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var selectedBrand = 0
    @EnvironmentObject var router: Router
    @StateObject var locationManager = LocationManager()
    @State var isLocationAuthorized = false
    @State var isShowRequestLocationAlert = false
    @State private var locationName: String = "Loading..."
    
    var brands: [Brand] = [
        Brand(image: "benz", title: "Mercedes-Benz"),
        Brand(image: "benz", title: "Tesla"),
        Brand(image: "benz", title: "Audi"),
        Brand(image: "benz", title: "BMW"),
        Brand(image: "benz", title: "Porsche"),
        Brand(image: "benz", title: "Toyota")
    ]
    
    var featuredCars: [FeaturedCar] = [
        FeaturedCar(
            image: "car",
            title: "2023 Mercedes S-Class",
            price: 89000,
            location: "Nairobi, Kenya",
            mileage: "12,000 km",
            year: "2023",
            condition: "Excellent",
            isNew: true,
            rating: 4.9,
            reviewCount: 124
        ),
        FeaturedCar(
            image: "car",
            title: "BMW X5 M Competition",
            price: 76500,
            location: "Mombasa, Kenya",
            mileage: "25,000 km",
            year: "2022",
            condition: "Very Good",
            isNew: false,
            rating: 4.8,
            reviewCount: 89
        ),
        FeaturedCar(
            image: "car",
            title: "Tesla Model S Plaid",
            price: 95000,
            location: "Kisumu, Kenya",
            mileage: "8,000 km",
            year: "2023",
            condition: "Like New",
            isNew: true,
            rating: 4.9,
            reviewCount: 156
        )
    ]
    
    var quickActions: [QuickAction] = [
        QuickAction(icon: "car.2", title: "Compare", color: .blue),
        QuickAction(icon: "wallet.bifold", title: "Live Offers", color: .red),
        QuickAction(icon: "bell", title: "Alerts", color: .orange),
        QuickAction(icon: "calendar", title: "Schedule", color: .green)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    headerView()
                    welcomeMessage()
                    searchSection()
                }
                .padding(.horizontal, 16)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Quick Actions", showSeeAll: false)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(quickActions) { action in
                                QuickActionCard(action: action){
                                    if(action.title == "Schedule"){
                                        router.push(.auctionSchedule)
                                    } else if (action.title == "Live Offers"){
                                        router.push(.auctionLiveBids)
                                    } else{
                                        router.push(.notification)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                // Live Auctions Banner
                LiveAuctionsBanner(
                    onViewAuction:{
                        router.push(.auctionLiveBids)
                    }
                )
                .padding(.horizontal, 16)
                
                // Top Brands
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Top Brands", showSeeAll: false)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Array(brands.enumerated()), id: \.offset) { index, brand in
                                EnhancedBrandView(
                                    brand: brand,
                                    isSelected: selectedBrand == index
                                ) {
                                    selectedBrand = index
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                // Featured Cars
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Featured Cars", showSeeAll: true)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(featuredCars) { car in
                                EnhancedCarCard(car: car) {
                                    router.push(.carDetails)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                // Recently Viewed
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Recently Viewed", showSeeAll: false)
                        .padding(.horizontal, 16)
                    
                    LazyVStack(spacing: 12) {
                        ForEach(featuredCars.prefix(2)) { car in
                            RecentlyViewedRow(car: car) {
                                router.push(.carDetails)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                
                // Bottom spacing for tab bar
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            updateLocationNameIfNeeded()
        }
        .background(Color.theme.surfaceColor.ignoresSafeArea(.all))
        .onChange(of: locationManager.authorizationStatus) { newStatus in
            Task {
                if newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways {
                    isLocationAuthorized = true
                    locationManager.startUpdatingLocation()
                } else {
                    isLocationAuthorized = false
                }
            }
        }
        .alert(isPresented: $isShowRequestLocationAlert) {
            Alert(
                title: Text("Location permision is required to proceed"),
                message: Text("Please enable location access in settings to proceed."),
                primaryButton: .default(Text("Open Settings")) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func updateLocationNameIfNeeded() {
        guard locationManager.latitude != 0.0 && locationManager.longitude != 0.0 else { return }
        Utils.shared.getCityAndCountry(latitude: locationManager.latitude, longitude: locationManager.longitude) { name in
            DispatchQueue.main.async {
                if let name = name {
                    locationName = name
                } else {
                    locationName = "Location not found"
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "location")
                    .foregroundColor(Color.theme.primaryColor)
                    .font(.system(size: 14))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your location")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(Color.theme.onSurfaceColor.opacity(0.6))
                    Text(locationName)
                        .font(.custom("Exo2-SemiBold", size: 14))
                        .foregroundColor(Color.theme.onSurfaceColor)
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    router.push(.notification)
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.theme.primaryColor.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "bell")
                            .foregroundColor(Color.theme.primaryColor)
                            .font(.system(size: 16))
                        
                        // Notification badge
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
                
                Button(action: {
                    router.push(.profile)
                }) {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.theme.primaryColor, lineWidth: 2)
                        )
                }
            }
        }
    }
    
    @ViewBuilder
    private func welcomeMessage() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Find your dream")
                .font(.custom("Exo2-Bold", size: 32))
                .foregroundColor(.theme.onSurfaceColor)
            
            HStack(spacing: 0) {
                Text("vehicle ")
                    .font(.custom("Exo2-Bold", size: 32))
                    .foregroundColor(.theme.onSurfaceColor)
                
                Text("today")
                    .font(.custom("Exo2-Bold", size: 32))
                    .foregroundColor(.theme.primaryColor)
            }
            
            Text("Discover premium cars at the best prices")
                .font(.custom("Exo2-Regular", size: 16))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.7))
                .padding(.top, 4)
        }
    }
    
    @ViewBuilder
    private func searchSection() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    
                    TextField("Search cars, brands, models...", text: $searchText)
                        .font(.custom("Exo2-Regular", size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.theme.surfaceColor)
                .cornerRadius(16)
                .shadow(color: Color.theme.onSurfaceColor.opacity(0.05), radius: 8, x: 0, y: 2)
                
                Button(action: {
                    // Filter action
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.theme.primaryColor)
                        .cornerRadius(16)
                }
            }
            
            // Search suggestions
            if !searchText.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(["Mercedes", "BMW", "Tesla", "Audi"], id: \.self) { suggestion in
                            Text(suggestion)
                                .font(.custom("Exo2-Medium", size: 12))
                                .foregroundColor(.theme.primaryColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.theme.primaryColor.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    @ViewBuilder
    private func sectionHeader(title: String, showSeeAll: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.custom("Exo2-Bold", size: 20))
                .foregroundColor(.theme.onSurfaceColor)
            
            Spacer()
            
            if showSeeAll {
                Button("See All") {
                    // See all action
                }
                .font(.custom("Exo2-Medium", size: 14))
                .foregroundColor(.theme.primaryColor)
            }
        }
    }
}

struct QuickActionCard: View {
    let action: QuickAction
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(action.color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: action.icon)
                        .foregroundColor(action.color)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Text(action.title)
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.theme.onSurfaceColor)
            }
            .frame(width: 80)
        }
        .buttonStyle(.plain)
    }
}


struct LiveAuctionsBanner: View {
    let onViewAuction: () -> Void
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.theme.onPrimaryColor)
                        .frame(width: 8, height: 8)
                    
                    Text("LIVE AUCTIONS")
                        .font(.custom("Exo2-Bold", size: 12))
                        .foregroundColor(.white)
                }
                
                Text("23 active auctions")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Starting from $15,000")
                    .font(.custom("Exo2-Bold", size: 16))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button("View") {
                onViewAuction()
            }
            .font(.custom("Exo2-Bold", size: 14))
            .foregroundColor(.theme.primaryColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(20)
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.primaryColor, Color.theme.primaryColor.opacity(0.8)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.theme.primaryColor.opacity(0.3), radius: 12, x: 0, y: 4)
    }
}

struct EnhancedBrandView: View {
    let brand: Brand
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.theme.primaryColor.opacity(0.1) : Color.theme.surfaceColor)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.theme.onSurfaceColor.opacity(0.08), radius: 12, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.theme.primaryColor : Color.clear, lineWidth: 2)
                    )
                
                Image(brand.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            Text(brand.title)
                .font(.custom("Exo2-Medium", size: 12))
                .foregroundColor(isSelected ? Color.theme.primaryColor : Color.theme.onSurfaceColor)
                .lineLimit(1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct EnhancedCarCard: View {
    let car: FeaturedCar
    let onTap: () -> Void
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with overlays
            ZStack(alignment: .topLeading) {
                Image(car.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 180)
                    .clipped()
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                
                // Badges
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        if car.isNew {
                            Text("NEW")
                                .font(.custom("Exo2-Bold", size: 8))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        
                        Text(car.condition)
                            .font(.custom("Exo2-Medium", size: 8))
                            .foregroundColor(.theme.primaryColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            isFavorite.toggle()
                        }
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .font(.system(size: 16))
                            .padding(8)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                .padding(12)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(car.title)
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        
                        Text(car.location)
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.8))
                    }
                }
                
                // Details
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Year")
                            .font(.custom("Exo2-Regular", size: 10))
                            .foregroundColor(.gray)
                        Text(car.year)
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Mileage")
                            .font(.custom("Exo2-Regular", size: 10))
                            .foregroundColor(.gray)
                        Text(car.mileage)
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                }
                
                // Price and rating
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Price")
                            .font(.custom("Exo2-Regular", size: 10))
                            .foregroundColor(.gray)
                        Text("$\(car.price, specifier: "%.0f")")
                            .font(.custom("Exo2-Bold", size: 18))
                            .foregroundColor(.theme.primaryColor)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        
                        Text("\(car.rating, specifier: "%.1f")")
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Text("(\(car.reviewCount))")
                            .font(.custom("Exo2-Regular", size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(16)
        }
        .frame(width: 280)
        .background(Color.theme.surfaceColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.onSurfaceColor.opacity(0.08), radius: 12, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
    }
}

struct RecentlyViewedRow: View {
    let car: FeaturedCar
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(car.image)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(car.title)
                    .font(.custom("Exo2-Bold", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                    Text(car.location)
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("$\(car.price, specifier: "%.0f")")
                        .font(.custom("Exo2-Bold", size: 14))
                        .foregroundColor(.theme.primaryColor)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                        
                        Text("\(car.rating, specifier: "%.1f")")
                            .font(.custom("Exo2-Medium", size: 12))
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                }
            }
            
            Spacer()
            
            Button("View") {
                onTap()
            }
            .font(.custom("Exo2-Medium", size: 12))
            .foregroundColor(.theme.primaryColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(Color.theme.primaryColor.opacity(0.1))
            .cornerRadius(16)
        }
        .padding(16)
        .background(Color.theme.surfaceColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.onSurfaceColor.opacity(0.05), radius: 8, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }
    
}

#Preview {
    HomeView()
    
}

