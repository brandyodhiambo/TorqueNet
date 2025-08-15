//
//  WishListView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct WishListView: View {
    var body: some View {
        var wishListCars: [WishList] = [
            WishList(
                image: "car",
                title: "Red Mazda 6 - Elite Estate",
                currentPrice:  25000.00,
                auctionEndDate: Date().addingTimeInterval(3600 * 5)
            ),
            WishList(
                image: "car",
                title: "Red Mazda 6 - Elite Estate",
                currentPrice:  25000.00,
                auctionEndDate: Date().addingTimeInterval(3600 * 2)
            ),
            WishList(
                image: "car",
                title: "Red Mazda 6 - Elite Estate",
                currentPrice:  25000.00,
                auctionEndDate: Date().addingTimeInterval(3600 * 2)
            ),
        ]
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(wishListCars) { wishListCar in
                    WishListCarCardView(
                        imageName: wishListCar.image,
                        title: wishListCar.title,
                        currentPrice: wishListCar.currentPrice,
                        auctionEndDate: wishListCar.auctionEndDate,
                        onFavoriteTapped: {},
                        onCardTapped: {}
                    )
                }
            }
        }
        .customTopAppBar(
            title: "Wishlist",
            leadingIcon: "",
            navbarTitleDisplayMode: .automatic,
            onLeadingTap: {
            },
            trailingIcon: "",
            onTrailingTap: {}
        )
        .background(Color.theme.surfaceColor)
    }
}

struct WishListCarCardView: View {
    var imageName: String
    var title: String
    var currentPrice: Double
    var auctionEndDate: Date
    var onFavoriteTapped: () -> Void?
    var onCardTapped: () -> Void?
    
    @State private var isFavorite = false
    @State private var timeRemaining: TimeInterval = 0
       
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 200)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                Button(action: {
                    withAnimation(.spring()) {
                        isFavorite.toggle()
                        onFavoriteTapped()
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            
            Text(title)
                .font(.custom("Exo2-Medium", size: 14))
                .fontWeight(.medium)
                .padding(.top, 5)
                .foregroundColor(.theme.onSurfaceColor)
            
            HStack {
                Text(String(format: "$%.2f", currentPrice))
                    .font(.custom("Exo2-Regular", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.theme.primaryColor)
                
                Spacer()
                
                Text(countdownString())
                    .font(.custom("Exo2-Black", size: 14))
                    .foregroundColor(timeRemaining > 0 ? .green : .red)
            }
            .padding(.top, 2)
            
        }
        .frame(width: .infinity)
        .padding()
        .onTapGesture {
            onCardTapped()
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
    NavigationView {
        WishListView()
    }
}
