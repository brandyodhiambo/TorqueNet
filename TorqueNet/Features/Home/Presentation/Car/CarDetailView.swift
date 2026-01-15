//
//  CarDetailView.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 14/08/2025.
//

import SwiftUI

struct CarDetailView: View {
    @EnvironmentObject var router:Router
    let car: CarModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                TabView {
                    ForEach(car.carImageUrls, id: \.self) { image in
                        //Image(imageName)
                        CustomImageView(url: image)
                            //.resizable()
                            .scaledToFill()
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 250)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(car.carName)
                            .font(.custom("Exo2-ExtraBold", size: 24))
                            .foregroundColor(Color.theme.primaryColor)
                            .fontWeight(.bold)
                        Spacer()
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(car.rating.description)
                            .font(.custom("Exo2-SemiBold", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.theme.onSurfaceColor)
                            
                        Text("(\(car.numberOfReviews)+ Reviews)")
                            .font(.custom("Exo2-SemiBold", size: 16))
                            .font(.subheadline)
                            .foregroundColor(.theme.onSurfaceColor)
                    }
                }

                HStack(spacing: 12) {
                    if car.ownerProfileImageUrl != nil {
                        CustomImageView(url: car.ownerProfileImageUrl ?? "", maxWidth: 50, height: 50,)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text(car.ownerName)
                            .font(.custom("Exo2-SemiBold", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.theme.onSurfaceColor)
                        Text(car.ownerRole)
                            .font(.custom("Exo2-SemiBold", size: 14))
                            .font(.subheadline)
                            .foregroundColor(.theme.onSurfaceColor)
                    }

                    Spacer()

                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "message")
                                .padding(10)
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                                .overlay(Circle().stroke(Color.theme.onSurfaceColor.opacity(0.3), lineWidth: 1))
                        }

                        Button(action: {}) {
                            Image(systemName: "phone")
                                .padding(10)
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                                .overlay(Circle().stroke(Color.theme.onSurfaceColor.opacity(0.3), lineWidth: 1))
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.primary)
                }
                .padding()
                .background(Color.theme.surfaceColor)
                .cornerRadius(12)
                .shadow(color: .theme.onSurfaceColor.opacity(0.2), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Info")
                        .font(.custom("Exo2-Medium", size: 16))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)

                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                        GridRow {
                            CarInfoItem(icon: "person.2.fill", text: "\(car.passengers) Passengers")
                            CarInfoItem(icon: "door.left.hand.open", text: "\(car.doors) Doors")
                        }
                        GridRow {
                            if car.hasAirConditioner{
                                CarInfoItem(icon: "snowflake", text: "Air Conditioner")
                            }
                            CarInfoItem(icon: "fuelpump.fill", text: "Fuel into: \(car.fuelPolicy)")
                        }
                        GridRow {
                            CarInfoItem(icon: "gearshift.layout.sixspeed", text: car.transmission)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Car Specs")
                        .font(.custom("Exo2-Medium", size: 16))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.onSurfaceColor)

                    HStack(spacing: 12) {
                        CarSpecCard(label: "Max Power", value: car.maxPower)
                        CarSpecCard(label: "0-60 Mph", value: car.zeroToSixty)
                        CarSpecCard(label: "Top Speed", value: car.topSpeed)
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Car Details",
            leadingIcon: "chevron.left",
            navbarTitleDisplayMode: .inline,
            onLeadingTap: {
                router.pop()
            },
            trailingIcon: "",
            onTrailingTap: {},
            trailingMenu: {}
        )
    }
}



struct CarInfoItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.theme.primaryColor)
                .frame(width: 20)
            Text(text)
                .font(.custom("Exo2-Regular", size: 14))
                .font(.subheadline)
                .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
        }
    }
}


struct CarSpecCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.custom("Exo2-Light", size: 12))
                .foregroundColor(.theme.onSurfaceColor)
            Text(value)
                .font(.custom("Exo2-Bold", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.theme.onSurfaceColor)

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.surfaceColor)
        .cornerRadius(12)
        .shadow(color: .theme.onSurfaceColor.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    NavigationView{
        CarDetailView(
            car:CarModel.preview
        )
    }
}
