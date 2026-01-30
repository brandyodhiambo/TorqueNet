//
//  WishListUiState.swift
//  TorqueNet
//
//  Created by MAC on 29/01/2026.
//

struct WishListUiState {
    var wishList: [WishList] = []
    var wish:WishList? = nil
    var errorMessage: String? = nil
    var showError: Bool = false
    var savedSuccess: Bool = false
    var showingDeleteAlert = false
    
    var wishlistState: FetchState = .good
    var toast: Toast? = nil
}
