//
//  NotificationScreen.swift
//  TorqueNet
//
//  Created by MAC on 16/09/2025.
//

import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [AuctionNotification] = sampleNotifications
    @State private var selectedFilter: NotificationFilter = .all
    @State private var showingMarkAllAsRead = false
    @State var isShowContextMenu: Bool = false
    @EnvironmentObject var router: Router
    
    var filteredNotifications: [AuctionNotification] {
        let filtered = selectedFilter == .all ? notifications : notifications.filter { $0.type == selectedFilter.notificationType }
        return filtered.sorted { $0.timestamp > $1.timestamp }
    }
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    if unreadCount > 0 {
                        Text("\(unreadCount) unread")
                            .font(.custom("Exo2-Regular", size: 14))
                            .foregroundColor(.theme.primaryColor)
                            .multilineTextAlignment(.leading)
                    }
                    // Filter tabs
                    filterTabs
                    
                    // Notifications list
                    notificationsList
                }

            }
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Notifications",
            leadingIcon: "chevron.left",
            onLeadingTap: { router.pop() },
            trailingMenu: {
                Menu {
                    if unreadCount > 0 {
                        Button("Mark all read") {
                            markAllAsRead()
                        }
                        .font(.custom("Exo2-Medium", size: 14))
                        .foregroundColor(.theme.primaryColor)
                    }
                    Button("Delete", role: .destructive) { }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        )
       
    }
    
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NotificationFilter.allCases, id: \.self) { filter in
                    FilterTab(
                        title: filter.title,
                        count: filter == .all ? notifications.count : notifications.filter { $0.type == filter.notificationType }.count,
                        isSelected: selectedFilter == filter,
                        color: filter.color
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredNotifications) { notification in
                    NotificationCard(notification: notification) {
                        markAsRead(notification)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .refreshable {
            await refreshNotifications()
        }
    }
    
    private func markAsRead(_ notification: AuctionNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead = true
        }
    }
    
    private func markAllAsRead() {
        for i in notifications.indices {
            notifications[i].isRead = true
        }
    }
    
    private func refreshNotifications() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // In real app, fetch from API
    }
}

// MARK: - Notification Card
struct NotificationCard: View {
    let notification: AuctionNotification
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(notification.type.color.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: notification.type.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(notification.type.color)
                
                // Pulse animation for live auctions
                if notification.type == .ongoing {
                    Circle()
                        .stroke(notification.type.color, lineWidth: 2)
                        .frame(width: 48, height: 48)
                        .scaleEffect(1.2)
                        .opacity(0)
                        .animation(.easeOut(duration: 1.5).repeatForever(), value: true)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(notification.title)
                        .font(.custom("Exo2-SemiBold", size: 16))
                        .foregroundColor(.theme.onSurfaceColor)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if !notification.isRead {
                        Circle()
                            .fill(notification.type.color)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(notification.message)
                    .font(.custom("Exo2-Regular", size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    if let bidAmount = notification.bidAmount {
                        Text("$\(bidAmount, specifier: "%.0f")")
                            .font(.custom("Exo2-Bold", size: 14))
                            .foregroundColor(notification.type.color)
                    }
                    
                    Spacer()
                    
                    Text(notification.timeAgo)
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            // Action indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(notification.isRead ? Color.theme.surfaceColor : Color.theme.surfaceColor.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(notification.isRead ? Color.clear : notification.type.color.opacity(0.2), lineWidth: 1)
                )
        )
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Filter Tab
struct FilterTab: View {
    let title: String
    let count: Int
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.custom("Exo2-Medium", size: 14))
                    .foregroundColor(isSelected ? .white : .theme.onSurfaceColor)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.custom("Exo2-Bold", size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : color)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isSelected ? .white.opacity(0.2) : color.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? color : Color.theme.surfaceColor)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - In-App Notification Banner
struct NotificationBanner: View {
    let notification: AuctionNotification
    @State private var isVisible = false
    let onDismiss: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.type.color)
                    .frame(width: 36, height: 36)
                
                Image(systemName: notification.type.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(notification.title)
                    .font(.custom("Exo2-SemiBold", size: 14))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(notification.message)
                    .font(.custom("Exo2-Regular", size: 12))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Dismiss button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            notification.type.color,
                            notification.type.color.opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: notification.type.color.opacity(0.3), radius: 8, x: 0, y: 4)
        )
        .offset(y: isVisible ? 0 : -100)
        .opacity(isVisible ? 1 : 0)
        .onTapGesture {
            onTap()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }
}

#Preview{
    NotificationsView()
}

// MARK: - Data Models
struct AuctionNotification: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    var isRead: Bool = false
    let bidAmount: Double?
    let auctionId: String
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

enum NotificationType: CaseIterable {
    case ongoing
    case newAuction
    case newBid
    case closed
    case extended
    
    var icon: String {
        switch self {
        case .ongoing: return "dot.radiowaves.left.and.right"
        case .newAuction: return "plus.circle.fill"
        case .newBid: return "hammer.fill"
        case .closed: return "checkmark.circle.fill"
        case .extended: return "clock.arrow.circlepath"
        }
    }
    
    var color: Color {
        switch self {
        case .ongoing: return .red
        case .newAuction: return .blue
        case .newBid: return .orange
        case .closed: return .green
        case .extended: return .purple
        }
    }
    
    var title: String {
        switch self {
        case .ongoing: return "Live"
        case .newAuction: return "New"
        case .newBid: return "Bids"
        case .closed: return "Closed"
        case .extended: return "Extended"
        }
    }
}

enum NotificationFilter: CaseIterable {
    case all
    case ongoing
    case newAuction
    case newBid
    case closed
    case extended
    
    var title: String {
        switch self {
        case .all: return "All"
        default: return notificationType?.title ?? ""
        }
    }
    
    var notificationType: NotificationType? {
        switch self {
        case .all: return nil
        case .ongoing: return .ongoing
        case .newAuction: return .newAuction
        case .newBid: return .newBid
        case .closed: return .closed
        case .extended: return .extended
        }
    }
    
    var color: Color {
        return notificationType?.color ?? .theme.primaryColor
    }
}

// MARK: - Sample Data
let sampleNotifications: [AuctionNotification] = [
    AuctionNotification(
        type: .newBid,
        title: "New bid placed!",
        message: "Someone just bid on 'Vintage Rolex Submariner 1960s'",
        timestamp: Date().addingTimeInterval(-300), // 5 minutes ago
        bidAmount: 46500,
        auctionId: "1"
    ),
    AuctionNotification(
        type: .ongoing,
        title: "Auction going live!",
        message: "'Abstract Canvas Oil Painting' auction has started",
        timestamp: Date().addingTimeInterval(-600), // 10 minutes ago
        bidAmount: nil,
        auctionId: "2"
    ),
    AuctionNotification(
        type: .extended,
        title: "Auction extended",
        message: "'1967 Ford Mustang Fastback' extended by 2 hours due to high activity",
        timestamp: Date().addingTimeInterval(-1800), // 30 minutes ago
        bidAmount: nil,
        auctionId: "3"
    ),
    AuctionNotification(
        type: .newAuction,
        title: "New auction created",
        message: "'Diamond Tennis Bracelet 5ct' is now available for bidding",
        timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
        isRead: true,
        bidAmount: nil,
        auctionId: "4"
    ),
    AuctionNotification(
        type: .closed,
        title: "Auction ended",
        message: "You won 'Bronze Sculpture Limited Edition' for $5,850!",
        timestamp: Date().addingTimeInterval(-7200), // 2 hours ago
        isRead: true,
        bidAmount: 5850,
        auctionId: "5"
    ),
    AuctionNotification(
        type: .newBid,
        title: "You've been outbid",
        message: "Your bid on 'Ming Dynasty Porcelain Vase' has been exceeded",
        timestamp: Date().addingTimeInterval(-10800), // 3 hours ago
        bidAmount: 127500,
        auctionId: "6"
    ),
    AuctionNotification(
        type: .ongoing,
        title: "Auction ending soon!",
        message: "'iPhone 15 Pro Max' auction ends in 10 minutes",
        timestamp: Date().addingTimeInterval(-14400), // 4 hours ago
        isRead: true,
        bidAmount: nil,
        auctionId: "7"
    )
]
