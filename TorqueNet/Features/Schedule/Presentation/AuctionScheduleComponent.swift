//
//  AuctionScheduleComponent.swift
//  TorqueNet
//
//  Created by MAC on 16/02/2026.
//

import SwiftUI

struct AuctionScheduleComponent: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var startingBid: String
    @Binding var scheduleError: String
    
    let onValidate: () -> Void
    
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schedule Auction")
                .font(.custom("Exo2-Medium", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Start Date & Time")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                
                Button(action: {
                    showStartDatePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.theme.primaryColor)
                        
                        Text(formatDate(startDate))
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                            .rotationEffect(.degrees(showStartDatePicker ? 180 : 0))
                    }
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.onSurfaceColor.opacity(0.2), lineWidth: 1)
                    )
                }
                
                if showStartDatePicker {
                    DatePicker(
                        "",
                        selection: $startDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.onSurfaceColor.opacity(0.1), lineWidth: 1)
                    )
                    .onChange(of: startDate) { _ in
                        onValidate()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("End Date & Time")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text("(Optional)")
                        .font(.custom("Exo2-Light", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                }
                
                Button(action: {
                    showEndDatePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                            .foregroundColor(.theme.primaryColor)
                        
                        Text(formatDate(endDate))
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                            .rotationEffect(.degrees(showEndDatePicker ? 180 : 0))
                    }
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.onSurfaceColor.opacity(0.2), lineWidth: 1)
                    )
                }
                
                if showEndDatePicker {
                    DatePicker(
                        "",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.theme.onSurfaceColor.opacity(0.1), lineWidth: 1)
                    )
                    .onChange(of: endDate) { _ in
                        onValidate()
                    }
                }
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.theme.primaryColor)
                    .font(.system(size: 14))
                
                Text("Duration: \(calculateDuration())")
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
            }
            .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Starting Bid")
                        .font(.custom("Exo2-Regular", size: 14))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    Text("(Optional)")
                        .font(.custom("Exo2-Light", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                }
                
                HStack {
                    Text("$")
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(.theme.primaryColor)
                    
                    TextField("0.00", text: $startingBid)
                        .font(.custom("Exo2-Regular", size: 14))
                        .keyboardType(.decimalPad)
                        .onChange(of: startingBid) { _ in
                            onValidate()
                        }
                }
                .padding()
                .background(Color.theme.surfaceColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.onSurfaceColor.opacity(0.2), lineWidth: 1)
                )
            }
            
            if !scheduleError.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                    
                    Text(scheduleError)
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.theme.primaryColor)
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scheduling Tips")
                        .font(.custom("Exo2-SemiBold", size: 13))
                        .foregroundColor(.theme.onSurfaceColor)
                    
                    Text("Set a start time at least 1 hour from now. Consider timezone differences for your bidders.")
                        .font(.custom("Exo2-Regular", size: 11))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .background(Color.theme.primaryColor.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .animation(.easeInOut(duration: 0.3), value: showStartDatePicker)
        .animation(.easeInOut(duration: 0.3), value: showEndDatePicker)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func calculateDuration() -> String {
        let interval = endDate.timeIntervalSince(startDate)
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 24 {
            let days = hours / 24
            let remainingHours = hours % 24
            return "\(days)d \(remainingHours)h"
        } else if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
