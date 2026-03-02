//
//  Route.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

enum Route: Hashable {
    case onboarding
    case dashboard
    
    case login
    case register
    case forgotPassword
    
    case home
    case carDetails(car:CarModel)
    case uploadCar
    
    case wishlist
    
    case auction
    case auctionDetails(auctionId:String)
    case auctionUpload
    case auctionLiveBids
    case auctionSchedule
    
    case settings
    case profile
    case changePassword
    case notification
    case editProfile
    case manageAuction
}
