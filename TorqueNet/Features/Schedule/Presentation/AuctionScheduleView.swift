//
//  AuctionScheduleScreen.swift
//  TorqueNet
//
//  Created by MAC on 17/09/2025.
//

import SwiftUI

struct AuctionScheduleView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var scheduledAuctions: [ScheduledAuction] = sampleScheduledAuctions
    @State private var showingDayDetail = false
    @State private var selectedDayAuctions: [ScheduledAuction] = []
    @EnvironmentObject var router: Router
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            VStack(spacing: 0) {
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(.custom("Exo2-Regular", size: 16))
                    .foregroundColor(.gray)
                // Calendar
                calendarView
                
                // Today's auctions (if any)
                todaysAuctionsView
            }
            .customTopAppBar(
                title: "Auction Schedule",
                leadingIcon: "chevron.left",
                onLeadingTap: { router.pop() },
                trailingMenu: {
                    HStack(spacing: 16) {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.theme.primaryColor)
                        }
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.theme.primaryColor)
                        }
                        
                        Button("Today") {
                            withAnimation(.easeInOut) {
                                currentMonth = Date()
                                selectedDate = Date()
                            }
                        }
                        .font(.custom("Exo2-Medium", size: 14))
                        .foregroundColor(.theme.primaryColor)
                    }
                }
            )
        }
        .sheet(isPresented: $showingDayDetail) {
            DayDetailView(
                date: selectedDate,
                auctions: selectedDayAuctions
            )
        }
        .background(Color.theme.surfaceColor)
    }

    
    private var calendarView: some View {
        VStack(spacing: 0) {
            // Weekday headers
            weekdayHeaders
            
            // Calendar grid
            calendarGrid
        }
        .padding(.horizontal, 20)
    }
    
    private var weekdayHeaders: some View {
        HStack {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                Text(weekday.uppercased())
                    .font(.custom("Exo2-SemiBold", size: 12))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 12)
    }
    
    private var calendarGrid: some View {
        let days = generateCalendarDays()
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 2) {
            ForEach(days, id: \.self) { date in
                CalendarDayView(
                    date: date,
                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                    isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                    auctions: auctionsForDate(date)
                ) {
                    selectedDate = date
                    selectedDayAuctions = auctionsForDate(date)
                    if !selectedDayAuctions.isEmpty {
                        showingDayDetail = true
                    }
                }
            }
        }
    }
    
    private var todaysAuctionsView: some View {
        let todaysAuctions = auctionsForDate(Date())
        
        return VStack(alignment: .leading, spacing: 16) {
            if !todaysAuctions.isEmpty {
                Divider()
                    .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Auctions")
                        .font(.custom("Exo2-Bold", size: 20))
                        .foregroundColor(.theme.onSurfaceColor)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(todaysAuctions) { auction in
                                TodayAuctionCard(auction: auction)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .padding(.top, 20)
    }
    
    func generateCalendarDays() -> [Date] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let startOfCalendar = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date] = []
        var currentDate = startOfCalendar
        
        for _ in 0..<42 { // 6 weeks * 7 days
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    private func auctionsForDate(_ date: Date) -> [ScheduledAuction] {
        return scheduledAuctions.filter { auction in
            calendar.isDate(auction.startDate, inSameDayAs: date)
        }.sorted { $0.startDate < $1.startDate }
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let auctions: [ScheduledAuction]
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    private var dayNumber: String {
        String(calendar.component(.day, from: date))
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Day number
            ZStack {
                Circle()
                    .fill(isSelected ? Color.theme.primaryColor : (isToday ? Color.theme.primaryColor.opacity(0.1) : Color.clear))
                    .frame(width: 32, height: 32)
                
                Text(dayNumber)
                    .font(.custom("Exo2-Medium", size: 16))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? .theme.primaryColor :
                        isCurrentMonth ? .theme.onSurfaceColor : .gray.opacity(0.5)
                    )
            }
            
            // Auction indicators
            VStack(spacing: 2) {
                ForEach(Array(auctions.prefix(3).enumerated()), id: \.offset) { index, auction in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.theme.primaryColor)
                        .frame(height: 3)
                        .opacity(isCurrentMonth ? 1 : 0.5)
                }
                
                if auctions.count > 3 {
                    Text("+\(auctions.count - 3)")
                        .font(.custom("Exo2-Bold", size: 8))
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 50, height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct TodayAuctionCard: View {
    let auction: ScheduledAuction
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Time indicator
            VStack(spacing: 4) {
                Text(timeFormatter.string(from: auction.startDate))
                    .font(.custom("Exo2-Bold", size: 14))
                    .foregroundColor(.theme.onSurfaceColor)
                
                if let endDate = auction.endDate {
                    Text("- \(timeFormatter.string(from: endDate))")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 80, alignment: .leading)
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.theme.primaryColor)
                    .frame(width: 4, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(auction.title)
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .lineLimit(2)
                    
                    if let startingBid = auction.startingBid {
                        Text("Starting at $\(startingBid, specifier: "%.0f")")
                            .font(.custom("Exo2-Medium", size: 14))
                            .foregroundColor(.theme.primaryColor)
                    }
                }
                
                Spacer()
                
                AuctionStatusBadge(status: auction.status)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.surfaceColor)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct AuctionStatusBadge: View {
    let status: AuctionStatus
    
    var body: some View {
        Text(status.rawValue.uppercased())
            .font(.custom("Exo2-Bold", size: 10))
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(status.color.opacity(0.1))
            )
    }
}

struct DayDetailView: View {
    let date: Date
    let auctions: [ScheduledAuction]
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(auctions) { auction in
                        TodayAuctionCard(auction: auction)
                    }
                }
                .padding(20)
            }
            .navigationTitle(dateFormatter.string(from: date))
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

#Preview{
    NavigationView{
        AuctionScheduleView()
    }
}




let sampleScheduledAuctions: [ScheduledAuction] = [
    // Today
    ScheduledAuction(
        title: "Vintage Watch Collection",
        startDate: Date().addingTimeInterval(3600), // 1 hour from now
        endDate: Date().addingTimeInterval(7200), // 2 hours from now
        startingBid: 500,
        status: .live,
        imageName: "vintage_watch"
    ),
    ScheduledAuction(
        title: "Modern Art Paintings",
        startDate: Date().addingTimeInterval(7200), // 2 hours from now
        endDate: Date().addingTimeInterval(14400), // 4 hours from now
        startingBid: 1000,
        status: .scheduled,
        imageName: "modern_art"
    ),
    
    // Tomorrow
    ScheduledAuction(
        title: "Classic Car Auction",
        startDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date().addingTimeInterval(10800)),
        startingBid: 25000,
        status: .scheduled,
        imageName: "classic_car"
    ),
    
    // Next week
    ScheduledAuction(
        title: "Diamond Jewelry Collection",
        startDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date().addingTimeInterval(7200)),
        startingBid: 2000,
        status: .scheduled,
        imageName: "diamond_ring"
    ),
    ScheduledAuction(
        title: "Antique Furniture",
        startDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date().addingTimeInterval(10800)),
        startingBid: 800,
        status: .scheduled,
        imageName: "antique_furniture"
    ),
    
    // Electronics spread across different days
    ScheduledAuction(
        title: "Latest Tech Gadgets",
        startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 7, to: Date().addingTimeInterval(5400)),
        startingBid: 300,
        status: .scheduled,
        imageName: "tech_gadgets"
    ),
    
    // More auctions for variety
    ScheduledAuction(
        title: "Rare Book Collection",
        startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date().addingTimeInterval(9000)),
        startingBid: 150,
        status: .scheduled,
        imageName: "rare_books"
    ),
    ScheduledAuction(
        title: "Contemporary Sculptures",
        startDate: Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 12, to: Date().addingTimeInterval(12600)),
        startingBid: 5000,
        status: .scheduled,
        imageName: "sculptures"
    )
]
