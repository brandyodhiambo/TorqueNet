//
//  Utils.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 04/08/2025.
//
import Foundation
import SwiftUI
import CoreLocation
import FirebaseCore

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
    
    
    func formatDateToHumanReadable(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString) else {
            return "Invalid date"
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        
        if let days = components.day, days > 0 {
            if days == 1 {
                return "Yesterday"
            } else if days < 7 {
                return "\(days) days ago"
            } else {
                let weeks = days / 7
                return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
            }
        }
        
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }
        
        return "Just now"
    }
    
    func formatStartDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func maskedUser(_ name: String) -> String {
        guard name.count > 4 else { return name }
        let prefix = name.prefix(4)
        let suffix = name.suffix(4)
        return "\(prefix)****\(suffix)"
    }

    

    
}
