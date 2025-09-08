//
//  AuctionView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

//struct AuctionView: View {
//    @EnvironmentObject var router:Router
//    var recomendedCars:[RecommendedCars] = [
//        RecommendedCars(image:"car",title: "Mercedes-Benz"),
//        RecommendedCars(image: "car", title: "Red Mazda 6 - Elite Estate"),
//        RecommendedCars(image: "car", title: "Red Mazda 2 - Hatchback"),
//        RecommendedCars(image: "car", title: "Tesla Model 3"),
//    ]
//    var body: some View {
//        NavigationView{
//            ScrollView(.vertical,showsIndicators: false){
//                VStack(alignment:.leading,spacing: 16){
//                    Text("Recomended for you")
//                        .font(.custom("Exo2-Bold", size: 18))
//                        .foregroundColor(.theme.onSurfaceColor)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(recomendedCars) { recommendCar in
//                                AuctionCarCardView(
//                                    imageName: recommendCar.image,
//                                    title: recommendCar.title,
//                                    onFavoriteTapped: {},
//                                    onCardTapped: {
//                                        router.push(.carDetails)
//                                    }
//                                )
//                            }
//                            
//                        }
//                    }
//                    
//                    Text("Ongoing Auctions")
//                        .font(.custom("Exo2-Bold", size: 18))
//                        .foregroundColor(.theme.onSurfaceColor)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(recomendedCars) { recommendCar in
//                                OngoingAuctionCarCardView(
//                                    imageName: recommendCar.image,
//                                    title: recommendCar.title,
//                                    onFavoriteTapped: {},
//                                    onCardTapped: {
//                                        router.push(.carDetails)
//                                    }
//                                )
//                            }
//                            
//                        }
//                    }
//                    
//                    Text("Upcoming Auctions")
//                        .font(.custom("Exo2-Bold", size: 18))
//                        .foregroundColor(.theme.onSurfaceColor)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(recomendedCars) { recommendCar in
//                                CarCardView(
//                                    imageName: recommendCar.image,
//                                    title: recommendCar.title,
//                                    onFavoriteTapped: {},
//                                    onCardTapped: {
//                                        router.push(.carDetails)
//                                    }
//                                )
//                            }
//                            
//                        }
//                    }
//                                    
//                }
//                .padding(.horizontal,8)
//                .customTopAppBar(
//                    title: "Auctions",
//                    leadingIcon: "",
//                    navbarTitleDisplayMode: .inline,
//                    onLeadingTap: {},
//                    trailingIcon: "",
//                    onTrailingTap: {
//                    }
//                )
//            }
//            .background(Color.theme.surfaceColor)
//        }
//        
//    }
//}
//
//struct AuctionCarCardView: View {
//    var imageName: String
//    var title: String
//    var onFavoriteTapped: () -> Void?
//    var onCardTapped: () -> Void?
//    
//    @State private var isFavorite = false
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            ZStack(alignment: .topLeading) {
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 220, height: 130)
//                    .cornerRadius(10)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//
//                Text("New")
//                    .font(.custom("Exo2-Light", size: 8))
//                    .foregroundColor(.theme.primaryColor)
//                    .padding(.top, 4)
//                    .padding([.leading, .trailing,.bottom], 4)
//                    .background(Color.theme.onPrimaryColor)
//                    .clipShape(Capsule())
//                    .padding(.top, 8)
//                    .padding([.leading, .trailing,.bottom], 8)
//            }
//            
//            VStack(alignment:.leading,spacing:4){
//                Text(title)
//                    .font(.custom("Exo2-Regular", size: 14))
//                    .fontWeight(.medium)
//                    .padding(.top, 5)
//                    .foregroundColor(.theme.onSurfaceColor)
//                
//                Text("Nairobi,Kenya")
//                    .font(.custom("Exo2-Regular", size: 12))
//                    .fontWeight(.medium)
//                    .foregroundColor(.theme.onSurfaceColor)
//                
//                HStack(spacing: 4) {
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                    Text("4.8")
//                        .font(.custom("Exo2-Medium", size: 14))
//                        .fontWeight(.semibold)
//                        .foregroundColor(.theme.onSurfaceColor)
//                        
//                    Text("(100+ Reviews)")
//                        .font(.custom("Exo2-SemiBold", size: 14))
//                        .font(.subheadline)
//                        .foregroundColor(.theme.onSurfaceColor)
//                }
//                
//            }
//        }
//        .frame(width: 220)
//        .onTapGesture {
//            onCardTapped()
//        }
//    }
//}
//
//struct OngoingAuctionCarCardView: View {
//    var imageName: String
//    var title: String
//    var onFavoriteTapped: () -> Void?
//    var onCardTapped: () -> Void?
//    
//    @State private var isFavorite = false
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            ZStack(alignment: .topTrailing) {
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 220, height: 130)
//                    .cornerRadius(10)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//                
//                Button(action: {
//                    withAnimation(.spring()) {
//                        isFavorite.toggle()
//                        onFavoriteTapped()
//                    }
//                }) {
//                    Image(systemName: isFavorite ? "heart.fill" : "heart")
//                        .foregroundColor(isFavorite ? .red : .white)
//                        .padding(8)
//                        .background(Color.black.opacity(0.4))
//                        .clipShape(Circle())
//                        .padding(8)
//                }
//            }
//            
//            Text(title)
//                .font(.custom("Exo2-Regular", size: 14))
//                .fontWeight(.medium)
//                .padding(.top, 5)
//                .foregroundColor(.theme.onSurfaceColor)
//            
//            HStack{
//                Text("$12,000")
//                    .font(.custom("Exo2-Regular", size: 12))
//                    .fontWeight(.medium)
//                    .foregroundColor(.red)
//                Text("$14,000")
//                    .font(.custom("Exo2-Regular", size: 12))
//                    .foregroundColor(.gray)
//                
//                Spacer()
//                
//                Text("Closed")
//                    .font(.custom("Exo2-Medium", size: 12))
//                    .foregroundColor(.red)
//            }
//        }
//        .frame(width: 220)
//        .onTapGesture {
//            onCardTapped()
//        }
//    }
//    
//}

import SwiftUI

struct AuctionView: View {
    @EnvironmentObject var router: Router
    @State private var searchText = ""
    @State private var selectedCategory = 0
    
    let categories = ["All", "Luxury", "SUV", "Sedan", "Sports", "Electric"]
    
    var featuredCars: [FeaturedAuction] = [
        FeaturedAuction(
            image: "car",
            title: "2023 Mercedes-Benz S-Class",
            currentBid: 89000,
            estimatedValue: 95000,
            timeRemaining: 3600 * 2 + 1800, // 2h 30m
            bidCount: 23,
            isLive: true,
            condition: "Excellent"
        ),
        FeaturedAuction(
            image: "car",
            title: "2022 BMW X5 M Competition",
            currentBid: 76500,
            estimatedValue: 82000,
            timeRemaining: 3600 * 5 + 900, // 5h 15m
            bidCount: 18,
            isLive: true,
            condition: "Very Good"
        )
    ]
    
    var recomendedCars: [RecommendedCars] = [
        RecommendedCars(image: "car", title: "Mercedes-Benz"),
        RecommendedCars(image: "car", title: "Red Mazda 6 - Elite Estate"),
        RecommendedCars(image: "car", title: "Red Mazda 2 - Hatchback"),
        RecommendedCars(image: "car", title: "Tesla Model 3"),
    ]
    
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
                            
                            TextField("Search auctions...", text: $searchText)
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
                                    selectedCategory = index
                                }) {
                                    Text(category)
                                        .font(.custom("Exo2-Medium", size: 14))
                                        .foregroundColor(selectedCategory == index ? .white : .theme.onSurfaceColor)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedCategory == index
                                                ? Color.theme.primaryColor
                                                : Color.gray.opacity(0.1)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Featured Auctions
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
                            
                            Spacer()
                            
                            Button("View All") {
                                // View all action
                            }
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.primaryColor)
                        }
                        .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(featuredCars) { car in
                                    FeaturedAuctionCard(auction: car) {
                                        router.push(.carDetails)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Live Auctions
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(1.2)
                                    .animation(.easeInOut(duration: 1).repeatForever(), value: true)
                                
                                Text("Live Auctions")
                                    .font(.custom("Exo2-Bold", size: 20))
                                    .foregroundColor(.theme.onSurfaceColor)
                            }
                            
                            Spacer()
                            
                            Text("12 active")
                                .font(.custom("Exo2-Medium", size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(recomendedCars) { car in
                                    LiveAuctionCard(
                                        imageName: car.image,
                                        title: car.title
                                    ) {
                                        router.push(.carDetails)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Upcoming Auctions
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
                            ForEach(recomendedCars.prefix(3)) { car in
                                UpcomingAuctionRow(
                                    imageName: car.image,
                                    title: car.title
                                ) {
                                    router.push(.carDetails)
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    
                    // Bottom Spacing
                    Spacer(minLength: 100)
                }
            }
            .background(Color.theme.surfaceColor)
            .customTopAppBar(
                title: "Auctions",
                leadingIcon: "",
                navbarTitleDisplayMode: .inline,
                onLeadingTap: {},
                trailingIcon: "bell",
                onTrailingTap: {
                    // Notifications action
                }
            )
        }
       
    }
}

// MARK: - Featured Auction Card
struct FeaturedAuctionCard: View {
    let auction: FeaturedAuction
    let onTap: () -> Void
    @State private var timeRemaining: TimeInterval
    
    init(auction: FeaturedAuction, onTap: @escaping () -> Void) {
        self.auction = auction
        self.onTap = onTap
        self._timeRemaining = State(initialValue: auction.timeRemaining)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with overlays
            ZStack(alignment: .topLeading) {
                Image(auction.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
                    .clipped()
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                
                // Live badge
                if auction.isLive {
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
                
                // Time remaining overlay
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
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(auction.title)
                        .font(.custom("Exo2-Bold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .lineLimit(2)
                    
                    Text(auction.condition)
                        .font(.custom("Exo2-Medium", size: 12))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(4)
                }
                
                // Bidding info
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Bid")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        Text("$\(auction.currentBid, specifier: "%.0f")")
                            .font(.custom("Exo2-Bold", size: 18))
                            .foregroundColor(.theme.primaryColor)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Est. Value")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        Text("$\(auction.estimatedValue, specifier: "%.0f")")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.gray)
                    }
                }
                
                // Bid count
                HStack {
                    Image(systemName: "hammer.fill")
                        .foregroundColor(.theme.primaryColor)
                        .font(.system(size: 12))
                    
                    Text("\(auction.bidCount) bids")
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
    
    private func formatTimeRemaining() -> String {
        let totalSeconds = Int(timeRemaining)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Live Auction Card
struct LiveAuctionCard: View {
    let imageName: String
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 120)
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
        .frame(width: 200)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Upcoming Auction Row
struct UpcomingAuctionRow: View {
    let imageName: String
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(.theme.onSurfaceColor)
                    .lineLimit(1)
                
                Text("Starts Tomorrow, 2:00 PM")
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.gray)
                
                Text("Est. $35,000 - $42,000")
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }
}



#Preview {
    AuctionView()
}
