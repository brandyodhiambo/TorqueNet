//
//  ValidatorUtils.swift
//  TorqueNet
//
//  Created by Brandy Odhiambo on 08/10/2025.
//

import Foundation

class ValidatorUtils{
    static let shared = ValidatorUtils()
    
    func validateEmail(email: String) -> String {
        if email.isEmpty {
            return "Email address is required."
        }
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        if regex?.firstMatch(in: email, options: [], range: range) == nil {
            return "Invalid email address format."
        }
        return ""
    }
    
    func validatePassword(password: String) -> [String] {
        var errors: [String] = []
        
        if password.count < 8 {
            errors.append("Password must be at least 8 characters long.")
        }
        if !password.contains(where: { $0.isUppercase }) {
            errors.append("Password must contain at least one uppercase letter.")
        }
        if !password.contains(where: { $0.isNumber }) {
            errors.append("Password must contain at least one digit.")
        }
        if !password.contains(where: { "!@#$%^&*".contains($0) }) {
            errors.append("Password must contain at least one special character.")
        }
        
        return errors
    }
    
    func validateConfirmPassword(password: String, confirmPassword: String) -> String {
        if password != confirmPassword {
            return "Passwords must match."
        }
        return ""
    }

    func validateName(name: String) -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return "Name is required."
        }
        
        if trimmedName.contains(" ") {
            return "Please enter a single name only."
        }
        
        let nameRegex = "^[A-Za-z'-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !predicate.evaluate(with: trimmedName) {
            return "Name can only contain letters, hyphens, and apostrophes."
        }
        
        return ""
    }
    
    func validatePhoneNumber(_ phone: String) -> String {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Phone number is required."
        }
        
        let cleaned = trimmed.replacingOccurrences(of: "[\\s-()]", with: "", options: .regularExpression)
        
        let patterns = [
            "^07\\d{8}$",        // 0712345678
            "^01\\d{8}$",        // 0112345678
            "^2547\\d{8}$",      // 254712345678
            "^2541\\d{8}$",      // 254112345678
            "^\\+2547\\d{8}$",   // +254712345678
            "^\\+2541\\d{8}$"    // +254112345678
        ]
        
        let isValid = patterns.contains { pattern in
            NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: cleaned)
        }
        
        return isValid ? "" : "Please enter a valid Kenyan phone number."
    }




}
