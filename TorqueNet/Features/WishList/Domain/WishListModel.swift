//
//  WishListModel.swift
//  TorqueNet
//
//  Created by MAC on 15/08/2025.
//
import Foundation


struct WishList:Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let currentPrice: Double
    let auctionEndDate: Date
}
