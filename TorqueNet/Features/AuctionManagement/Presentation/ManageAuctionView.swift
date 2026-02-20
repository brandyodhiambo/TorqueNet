//
//  ManageAuctionView.swift
//  TorqueNet
//
//  Created by MAC on 20/02/2026.
//

import SwiftUI
import FirebaseAuth


struct ManageAuctionsView: View {
    @StateObject private var viewModel: ManageAuctionViewModel
    @EnvironmentObject var router: Router
    
    init() {
        let repository = ManageAuctionRepositoryImpl()
        let fetchUseCase = FetchSellerAuctionsUseCase(repository: repository)
        let updateUseCase = UpdateAuctionUseCase(repository: repository)
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        _viewModel = StateObject(wrappedValue: ManageAuctionViewModel(
            fetchSellerAuctionsUseCase: fetchUseCase,
            updateAuctionUseCase: updateUseCase,
            currentUserId: userId
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Chips
            filterChipsView
            
            Divider()
            
            // Content
            Group {
                if viewModel.uiState.isLoading {
                    loadingView
                } else if viewModel.uiState.hasError {
                    errorView
                } else if viewModel.uiState.filteredAuctions.isEmpty {
                    emptyView
                } else {
                    auctionListView
                }
            }
        }
        .background(Color.theme.surfaceColor)
        .customTopAppBar(
            title: "Manage Auctions",
            leadingIcon: "chevron.left",
            navbarTitleDisplayMode: .inline,
            onLeadingTap: {
                router.pop()
            },
            trailingIcon: "",
            onTrailingTap: {},
            trailingMenu: {}
        )
        .sheet(isPresented: $viewModel.uiState.showEditSheet) {
            if let auction = viewModel.uiState.selectedAuction {
                EditAuctionSheet(auction: auction, viewModel: viewModel)
            }
        }
        .task {
            await viewModel.loadAuctions()
        }
        .alert("Error", isPresented: $viewModel.uiState.hasError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.uiState.errorMessage)
        }
    }
        
    private var filterChipsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All",
                    count: viewModel.uiState.auctions.count,
                    isSelected: viewModel.uiState.selectedFilter == nil
                ) {
                    viewModel.filterByStatus(nil)
                }
                
                ForEach(AuctionStatus.allCases, id: \.self) { status in
                    FilterChip(
                        title: status.rawValue,
                        count: viewModel.uiState.auctions.filter { $0.status == status }.count,
                        isSelected: viewModel.uiState.selectedFilter == status,
                        color: status.color
                    ) {
                        viewModel.filterByStatus(status)
                    }
                }
            }
            .padding()
        }
        .background(Color.theme.surfaceColor)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .theme.primaryColor))
                .scaleEffect(1.5)
            Text("Loading your auctions...")
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text(viewModel.uiState.errorMessage)
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.theme.onSurfaceColor)
                .multilineTextAlignment(.center)
            Button(action: {
                Task { await viewModel.loadAuctions() }
            }) {
                Text("Retry")
                    .font(.custom("Exo2-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.theme.primaryColor)
                    .cornerRadius(12)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 40))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
            Text(viewModel.uiState.selectedFilter == nil ? "No auctions yet" : "No \(viewModel.uiState.selectedFilter?.rawValue ?? "") auctions")
                .font(.custom("Exo2-SemiBold", size: 16))
                .foregroundColor(.theme.onSurfaceColor)
            Text("Start by uploading your first car for auction")
                .font(.custom("Exo2-Regular", size: 14))
                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var auctionListView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.uiState.filteredAuctions) { auction in
                    ManageAuctionCard(auction: auction) {
                        viewModel.selectAuctionForEdit(auction)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Filter Chip Component

struct FilterChip: View {
    let title: String
    let count: Int
    var isSelected: Bool
    var color: Color = .theme.primaryColor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.custom("Exo2-SemiBold", size: 13))
                
                Text("(\(count))")
                    .font(.custom("Exo2-Regular", size: 12))
            }
            .foregroundColor(isSelected ? .white : .theme.onSurfaceColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color.theme.onSurfaceColor.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

// MARK: - Auction Card Component

struct ManageAuctionCard: View {
    let auction: ManageAuctionItem
    let onEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Car Image
                AsyncImage(url: URL(string: auction.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.onSurfaceColor.opacity(0.1))
                        .overlay(
                            Image(systemName: "car.fill")
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.3))
                        )
                }
                .frame(width: 100, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    // Title & Status
                    HStack {
                        Text(auction.carTitle)
                            .font(.custom("Exo2-SemiBold", size: 15))
                            .foregroundColor(.theme.onSurfaceColor)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(auction.status.rawValue)
                            .font(.custom("Exo2-Regular", size: 10))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(auction.status.color)
                            .cornerRadius(6)
                    }
                    
                    // Lot Number
                    Text("Lot #\(auction.lotNumber)")
                        .font(.custom("Exo2-Regular", size: 12))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    
                    // Bids
                    HStack(spacing: 4) {
                        Image(systemName: "hammer.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.theme.primaryColor)
                        Text("\(auction.bidCount) bids")
                            .font(.custom("Exo2-Regular", size: 12))
                            .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                    }
                }
            }
            
            Divider()
            
            // Details Row
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start Date")
                        .font(.custom("Exo2-Regular", size: 11))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.5))
                    Text(formatDate(auction.startDate))
                        .font(.custom("Exo2-SemiBold", size: 12))
                        .foregroundColor(.theme.onSurfaceColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("End Date")
                        .font(.custom("Exo2-Regular", size: 11))
                        .foregroundColor(.theme.onSurfaceColor.opacity(0.5))
                    Text(formatDate(auction.endDate))
                        .font(.custom("Exo2-SemiBold", size: 12))
                        .foregroundColor(.theme.onSurfaceColor)
                }
                
                Spacer()
                
                Button(action: onEdit) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("Edit")
                            .font(.custom("Exo2-SemiBold", size: 13))
                    }
                    .foregroundColor(.theme.primaryColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.theme.primaryColor.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.theme.surfaceColor)
        .cornerRadius(12)
        .shadow(color: .theme.onSurfaceColor.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Edit Auction Sheet

struct EditAuctionSheet: View {
    let auction: ManageAuctionItem
    @ObservedObject var viewModel: ManageAuctionViewModel
    
    @State private var selectedStatus: AuctionStatus
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    
    init(auction: ManageAuctionItem, viewModel: ManageAuctionViewModel) {
        self.auction = auction
        self.viewModel = viewModel
        _selectedStatus = State(initialValue: auction.status)
        _startDate = State(initialValue: auction.startDate)
        _endDate = State(initialValue: auction.endDate)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Car Preview
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: auction.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.onSurfaceColor.opacity(0.1))
                        }
                        .frame(width: 80, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(auction.carTitle)
                                .font(.custom("Exo2-SemiBold", size: 16))
                                .foregroundColor(.theme.onSurfaceColor)
                            Text("Lot #\(auction.lotNumber)")
                                .font(.custom("Exo2-Regular", size: 13))
                                .foregroundColor(.theme.onSurfaceColor.opacity(0.6))
                        }
                    }
                    .padding()
                    .background(Color.theme.surfaceColor)
                    .cornerRadius(12)
                    
                    // Status Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Auction Status")
                            .font(.custom("Exo2-Medium", size: 16))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Picker("Status", selection: $selectedStatus) {
                            ForEach(AuctionStatus.allCases, id: \.self) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Start Date
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Start Date & Time")
                            .font(.custom("Exo2-Medium", size: 16))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Button(action: { showStartDatePicker.toggle() }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.theme.primaryColor)
                                Text(formatDateTime(startDate))
                                    .font(.custom("Exo2-Regular", size: 14))
                                    .foregroundColor(.theme.onSurfaceColor)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                                    .rotationEffect(.degrees(showStartDatePicker ? 180 : 0))
                            }
                            .padding()
                            .background(Color.theme.surfaceColor)
                            .cornerRadius(12)
                        }
                        
                        if showStartDatePicker {
                            DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color.theme.surfaceColor)
                                .cornerRadius(12)
                        }
                    }
                    
                    // End Date
                    VStack(alignment: .leading, spacing: 12) {
                        Text("End Date & Time")
                            .font(.custom("Exo2-Medium", size: 16))
                            .foregroundColor(.theme.onSurfaceColor)
                        
                        Button(action: { showEndDatePicker.toggle() }) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.theme.primaryColor)
                                Text(formatDateTime(endDate))
                                    .font(.custom("Exo2-Regular", size: 14))
                                    .foregroundColor(.theme.onSurfaceColor)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.theme.onSurfaceColor.opacity(0.4))
                                    .rotationEffect(.degrees(showEndDatePicker ? 180 : 0))
                            }
                            .padding()
                            .background(Color.theme.surfaceColor)
                            .cornerRadius(12)
                        }
                        
                        if showEndDatePicker {
                            DatePicker("", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color.theme.surfaceColor)
                                .cornerRadius(12)
                        }
                    }
                    
                    // Save Button
                    Button(action: {
                        Task {
                            await viewModel.updateAuction(
                                status: selectedStatus,
                                startDate: startDate,
                                endDate: endDate
                            )
                        }
                    }) {
                        HStack {
                            if viewModel.uiState.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(viewModel.uiState.isLoading ? "Updating..." : "Update Auction")
                                .font(.custom("Exo2-SemiBold", size: 16))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.uiState.isLoading ? Color.gray : Color.theme.primaryColor)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.uiState.isLoading)
                }
                .padding()
            }
            .background(Color.theme.surfaceColor.opacity(0.5))
            .navigationTitle("Edit Auction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        viewModel.uiState.showEditSheet = false
                    }
                    .foregroundColor(.theme.primaryColor)
                }
            }
        }
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ManageAuctionsView()
}
