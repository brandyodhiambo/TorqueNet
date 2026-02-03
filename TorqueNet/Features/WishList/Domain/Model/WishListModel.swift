//
//  WishListModel.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 15/08/2025.
//
import Foundation


struct WishList:Identifiable {
    let id:String
    let image: String
    let title: String
    let currentPrice: Double
    let auctionEndDate: Date
    
    
    static func from(entity: WishListEntity) -> WishList {
        return WishList(
            id: entity.id ?? "",
            image: entity.image ?? "",
            title: entity.title ?? "",
            currentPrice: entity.currentPrice ?? 0.0,
            auctionEndDate: entity.auctionEndDate ?? Date()
        )
    }
}
