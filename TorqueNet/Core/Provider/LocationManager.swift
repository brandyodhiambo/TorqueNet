//
//  LocationManager.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 10/10/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var showLocationAlert = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        print("DEBUG: Location updated to lat \(latitude), lng \(longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Location manager failed with error: \(error)")
        showLocationAlert = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        authorizationStatus = manager.authorizationStatus
        print("DEBUG: locationManagerDidChangeAuthorization authorizationStatus : \(authorizationStatus)")
        switch authorizationStatus {
        case .notDetermined:
              manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        @unknown default:
            break
        }
        
    }
}
