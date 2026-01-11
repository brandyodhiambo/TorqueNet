//
//  HomeViewModel.swift
//  TorqueNet
//
//  Created by MAC on 01/12/2025.
//
import Foundation
import UIKit

@MainActor
class HomeViewModel:ObservableObject{
    @Published var searchText: String = ""
    @Published var selectedBrandIndex = 0
    @Published var selectedBrand:Brand? = nil
    @Published var isLocationAuthorized = false
    @Published var isShowRequestLocationAlert = false
    @Published var isShowTopBrandUrl = false
    @Published var locationName: String = "Loading..."
    @Published var currentUser: User?
    @Published var carUiState = CarUiState()
    
    var brands: [Brand] = [
        Brand(image: "benz", title: "Mercedes-Benz",link: "https://www.mercedes-benz.com/en/"),
        Brand(image: "tesla", title: "Tesla",link: "https://www.tesla.com/"),
        Brand(image: "audi", title: "Audi",link: "https://www.audi.com/en/" ),
        Brand(image: "bmw", title: "BMW",link: "https://www.bmw.co.ke/en/index.html" ),
        Brand(image: "porsche", title: "Porsche",link: "https://www.porsche.com/international/" ),
        Brand(image: "toyota", title: "Toyota",link: "https://www.toyota.com/cars/")
    ]
        
    var quickActions: [QuickAction] = [
        //QuickAction(icon: "car.2", title: "Compare", color: .blue),
        QuickAction(icon: "wallet.bifold", title: "Live Offers", color: .red),
        QuickAction(icon: "bell", title: "Alerts", color: .orange),
        QuickAction(icon: "calendar", title: "Schedule", color: .green)
    ]
    
    func applyFilters() {
        let text = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        carUiState.filteredCars = carUiState.fetchedCars.filter { car in
            let matchesText =
                text.isEmpty ||
                car.carName.lowercased().contains(text) ||
                car.carModel.lowercased().contains(text)

            let matchesBrand =
                selectedBrand == nil ||
            car.carModel.lowercased().contains(selectedBrand?.title.lowercased() ?? "")

            return matchesText && matchesBrand
        }
    }
    
    func updateSaerchText(_ text: String) {
        self.searchText = text
        applyFilters()
    }

    
}
