//
//  Utils.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//
import Foundation
import SwiftUI
import CoreLocation

struct Utils {
    static let shared = Utils()
    // Dismiss keyboard
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getCityAndCountry(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
          let location = CLLocation(latitude: latitude, longitude: longitude)
          let geocoder = CLGeocoder()

          geocoder.reverseGeocodeLocation(location) { placemarks, error in
              if let error = error {
                  print("Reverse geocoding failed: \(error.localizedDescription)")
                  completion(nil)
                  return
              }

              guard let placemark = placemarks?.first else {
                  completion(nil)
                  return
              }

              if let city = placemark.locality,
                 let country = placemark.country {
                  completion("\(city), \(country)")
              } else {
                  completion(nil)
              }
          }
      }
    
    func splitFullName(_ fullName: String) -> (firstName: String, lastName: String) {
        let components = fullName.components(separatedBy: " ")
        let first = components.first ?? ""
        let last = components.dropFirst().joined(separator: " ")
        return (first, last)
    }
    
}
