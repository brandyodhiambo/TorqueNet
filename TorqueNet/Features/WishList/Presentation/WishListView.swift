//
//  WishListView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct WishListView: View {
    @State var text: String = ""
    let wishListCars: [WishList] = [
        WishList(
            image: "car",
            title: "Red Mazda 6 - Elite Estate",
            currentPrice: 25000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 5)
        ),
        WishList(
            image: "car",
            title: "Red Mazda 6 - Elite Estate",
            currentPrice: 25000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 2)
        ),
        WishList(
            image: "car",
            title: "Red Mazda 6 - Elite Estate",
            currentPrice: 25000.00,
            auctionEndDate: Date().addingTimeInterval(3600 * 2)
        ),
    ]
    @State var carCategoryList = [
        CarCategory(id: 0, name: "All", icon: "folder.fill.badge.person.crop", isSelected: true),
        CarCategory(id: 1, name: "Year", icon: "folder.fill.badge.person.crop", isSelected: false),
        CarCategory(id: 2, name: "Make", icon: "person.fill", isSelected: false),
        CarCategory(id: 3, name: "Model", icon: "list.bullet.clipboard.fill", isSelected: false),
        CarCategory(id: 4, name: "Location", icon: "suitcase.fill", isSelected: false),
    ]
    private func selectCategory(withId id: Int) {
        for index in carCategoryList.indices {
            carCategoryList[index].isSelected = (carCategoryList[index].id == id)
        }
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false) {
                VStack(spacing: 16){
                    //Categories View
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing: 14){
                            ForEach($carCategoryList, id: \.self) { $category in
                                let cardbgColor: Color = category.isSelected ? Color.theme.primaryColor : Color.theme.surfaceColor.opacity(0.9)
                                
                                let iconForgroundColor: Color = category.isSelected ? Color.theme.onPrimaryColor : Color.theme.primaryColor
                                let progressColor: Color = category.isSelected ? Color.theme.onPrimaryColor.opacity(0.7) : Color.gray
                                
                                CustomCardView(
                                    title: nil,
                                    bgColor:cardbgColor,
                                    contentColor: iconForgroundColor,
                                    subtitle: nil,
                                    onTap:{
                                        selectCategory(withId: category.id)
                                    },
                                    content: {
                                        Text(category.name)
                                            .font(.custom("Exo2-Medium", size: 16))
                                            .foregroundColor(iconForgroundColor)
                                    }
                                )
                            }
                        }.padding(4)
                    }
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
            }
                .padding(.horizontal,8)
                .customTopAppBar(
                    title: "My Wishlist",
                    leadingIcon: "",
                    navbarTitleDisplayMode: .inline,
                    onLeadingTap: {},
                    trailingIcon: "trash.fill",
                    onTrailingTap: {
                       print("delete all wishlist")
                    }
                )
            }
            .background(Color.theme.surfaceColor)
        }
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
    @State private var timeRemaining: TimeInterval = 15
       
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
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
            .padding()
            .onAppear {
                updateTimeRemaining()
            }
            .onReceive(timer) { _ in
                updateTimeRemaining()
            }
            .onTapGesture {
                onCardTapped()
            }
    }
    
    private func updateTimeRemaining() {
            let now = Date()
            timeRemaining = auctionEndDate.timeIntervalSince(now)
            
            // Stop the timer if auction has ended (optional optimization)
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
    NavigationView {
        WishListView()
    }
}
