//
//  HomeView.swift
//  TorqueNet
//
//  Created by MAC on 05/08/2025.
//

import SwiftUI

struct HomeView: View {
    @State var text: String = ""
    var brands: [Brand] = [
        Brand(
            image: "benz",
            title: "Mercedes-Benz"
        ),
        Brand(
            image: "benz",
            title: "Tesla"
        ),
        Brand(
            image: "benz",
            title: "Audi"
        ),
        Brand(
            image: "benz",
            title: "BMW"
        ),
    ]
    
    var recomendedCars:[RecommendedCars] = [
        RecommendedCars(image:"car",title: "Mercedes-Benz"),
        RecommendedCars(image: "car", title: "Red Mazda 6 - Elite Estate"),
        RecommendedCars(image: "car", title: "Red Mazda 2 - Hatchback"),
        RecommendedCars(image: "car", title: "Tesla Model 3"),
    ]
    var body: some View {
        ZStack {
            Color.theme.surfaceColor
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "bell")
                                .foregroundColor(Color.theme.onSurfaceColor.opacity(0.4))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Your location")
                                    .font(.custom("Exo2-Medium", size: 12))
                                    .foregroundColor(Color.theme.onSurfaceColor.opacity(0.4))
                                Text("Brandy Odhiambo")
                                    .font(.custom("Exo2-SemiBold", size: 16))
                                    .foregroundColor(Color.theme.onSurfaceColor)
                            }
                        }
                        Spacer()
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    
                    Text("Find your favourite\nvehicle.")
                        .font(.custom("Exo2-Bold", size: 28))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    InputFieldView(
                        placeHolder: "Search vehicle..",
                        text: $text,
                        foregroundColor: .theme.primaryColor,
                        backgroundColor: .theme.surfaceColor.opacity(0.7),
                        keyboardType: .default,
                        inputFieldStyle: .outlined
                    )
                    
                  
                    sectionHeader(title: "Top Brands")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(brands) { brand in
                                BrandLogoView(imageName: brand.image, brandName:brand.title)
                            }
                        }
                    }
                    
                
                    sectionHeader(title: "Recommended Cars")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(recomendedCars) { recommendCar in
                                CarCardView(imageName: recommendCar.image, title: recommendCar.title,onFavoriteTapped: {})
                            }
                            
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("Exo2-Bold", size: 18))
                .foregroundColor(.theme.onSurfaceColor)
            Spacer()
            Text("See All")
                .foregroundColor(.theme.primaryColor)
                .font(.custom("Exo2-Regular", size: 16))
        }
    }
}


struct BrandLogoView: View {
    var imageName: String
    var brandName: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(width: 70, height: 70)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                )
            Text(brandName)
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(Color.theme.onSurfaceColor)
        }
    }
}

struct CarCardView: View {
    var imageName: String
    var title: String
    var onFavoriteTapped: () -> Void?
    
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
        }
        .frame(width: 220)
    }
}


#Preview {
    HomeView()
}

