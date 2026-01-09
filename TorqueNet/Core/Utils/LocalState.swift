//
//  LocalState.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 05/08/2025.
//

import Foundation
import SwiftUI

enum Keys: String{
    case isFirstTimeUsingApp
    case isDarkModeOn
    case isLoggedIn
    case isLogout
    case recentlyViewedCarsIds
}

public class LocalState {
    @AppStorage(Keys.isFirstTimeUsingApp.rawValue) static var isFirstTimeUsingApp: Bool = true
    @AppStorage(Keys.isDarkModeOn.rawValue) static var isDarkModeOn: String?
    @AppStorage(Keys.isLoggedIn.rawValue) static var isLoggedIn: Bool = false
    @AppStorage(Keys.isLogout.rawValue) static var isLogout: Bool = false
    @AppStorage(Keys.recentlyViewedCarsIds.rawValue)
       private static var recentlyViewedCarIdsData: Data = Data()
       static var recentlyViewedCarIds: [String] {
           get {
               guard !recentlyViewedCarIdsData.isEmpty else { return [] }
               return (try? JSONDecoder().decode([String].self, from: recentlyViewedCarIdsData)) ?? []
           }
           set {
               recentlyViewedCarIdsData = (try? JSONEncoder().encode(newValue)) ?? Data()
           }
       }
}
