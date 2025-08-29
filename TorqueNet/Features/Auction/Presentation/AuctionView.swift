//
//  AuctionView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct AuctionView: View {
    @EnvironmentObject var router:Router
    var recomendedCars:[RecommendedCars] = [
        RecommendedCars(image:"car",title: "Mercedes-Benz"),
        RecommendedCars(image: "car", title: "Red Mazda 6 - Elite Estate"),
        RecommendedCars(image: "car", title: "Red Mazda 2 - Hatchback"),
        RecommendedCars(image: "car", title: "Tesla Model 3"),
    ]
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment:.leading,spacing: 16){
                    Text("Recomended for you")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recomendedCars) { recommendCar in
                                AuctionCarCardView(
                                    imageName: recommendCar.image,
                                    title: recommendCar.title,
                                    onFavoriteTapped: {},
                                    onCardTapped: {
                                        router.push(.carDetails)
                                    }
                                )
                            }
                            
                        }
                    }
                    
                    Text("Ongoing Auctions")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recomendedCars) { recommendCar in
                                OngoingAuctionCarCardView(
                                    imageName: recommendCar.image,
                                    title: recommendCar.title,
                                    onFavoriteTapped: {},
                                    onCardTapped: {
                                        router.push(.carDetails)
                                    }
                                )
                            }
                            
                        }
                    }
                    
                    Text("Upcoming Auctions")
                        .font(.custom("Exo2-Bold", size: 18))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recomendedCars) { recommendCar in
                                CarCardView(
                                    imageName: recommendCar.image,
                                    title: recommendCar.title,
                                    onFavoriteTapped: {},
                                    onCardTapped: {
                                        router.push(.carDetails)
                                    }
                                )
                            }
                            
                        }
                    }
                                    
                }
                .padding(.horizontal,8)
                .customTopAppBar(
                    title: "Auctions",
                    leadingIcon: "",
                    navbarTitleDisplayMode: .inline,
                    onLeadingTap: {},
                    trailingIcon: "",
                    onTrailingTap: {
                    }
                )
            }
            .background(Color.theme.surfaceColor)
        }
        
    }
}

struct AuctionCarCardView: View {
    var imageName: String
    var title: String
    var onFavoriteTapped: () -> Void?
    var onCardTapped: () -> Void?
    
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 130)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                Text("New")
                    .font(.custom("Exo2-Light", size: 8))
                    .foregroundColor(.theme.primaryColor)
                    .padding(.top, 4)
                    .padding([.leading, .trailing,.bottom], 4)
                    .background(Color.theme.onPrimaryColor)
                    .clipShape(Capsule())
                    .padding(.top, 8)
                    .padding([.leading, .trailing,.bottom], 8)
            }
            
            VStack(alignment:.leading,spacing:4){
                Text(title)
                    .font(.custom("Exo2-Regular", size: 14))
                    .fontWeight(.medium)
                    .padding(.top, 5)
                    .foregroundColor(.theme.onSurfaceColor)
                
                Text("Nairobi,Kenya")
                    .font(.custom("Exo2-Regular", size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.theme.onSurfaceColor)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.8")
                        .font(.custom("Exo2-SemiBold", size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.theme.onSurfaceColor)
                        
                    Text("(100+ Reviews)")
                        .font(.custom("Exo2-SemiBold", size: 14))
                        .font(.subheadline)
                        .foregroundColor(.theme.onSurfaceColor)
                }
                
            }
        }
        .frame(width: 220)
        .onTapGesture {
            onCardTapped()
        }
    }
}

struct OngoingAuctionCarCardView: View {
    var imageName: String
    var title: String
    var onFavoriteTapped: () -> Void?
    var onCardTapped: () -> Void?
    
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 130)
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
                .font(.custom("Exo2-Regular", size: 14))
                .fontWeight(.medium)
                .padding(.top, 5)
                .foregroundColor(.theme.onSurfaceColor)
            
            HStack{
                Text("$12,000")
                    .font(.custom("Exo2-Regular", size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                Text("$14,000")
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Closed")
                    .font(.custom("Exo2-Medium", size: 12))
                    .foregroundColor(.red)
            }
        }
        .frame(width: 220)
        .onTapGesture {
            onCardTapped()
        }
    }
    
}

#Preview {
    AuctionView()
}
