//
//  WishListViewModel.swift
//  TorqueNet
//
//  Created by MAC on 29/01/2026.
//
import Foundation

@MainActor
class WishListViewModel: ObservableObject {
    @Published var wishListUiState = WishListUiState()
    private let repository: WishListRepository = WishListRepositoryImpl.shared
    
    func loadWishList(
        onSuccess:()->Void,
    ) {
        do{
            wishListUiState.wishlistState = .isLoading
            wishListUiState.wishList = try repository.getAll()
            wishListUiState.wishlistState = .good
            onSuccess()
        } catch {
            wishListUiState.wishlistState = .error("Failed to fetch wishlist")
            wishListUiState.errorMessage = "Failed to fetch wishlist"
            wishListUiState.showError = true
        }
    }
    
    func loadWish(id:String){
        do{
            wishListUiState.wishlistState = .isLoading
            let wish = try repository.getWishById(id: id)
            wishListUiState.wish = wish
            wishListUiState.wishlistState = .good
        } catch{
            wishListUiState.wishlistState = .error("Failed to fetch wish")
            wishListUiState.errorMessage = "Failed to fetch wish"
            wishListUiState.showError = true
            
        }
    }
    
    func createWish(
        wish: WishList,
        onSuccess:()->Void,
        onFaliure:(String)->Void){
        do{
            wishListUiState.wishlistState = .isLoading
            _ = try repository.createWish(wish: wish)
            wishListUiState.wishlistState = .good
            onSuccess()
        } catch{
            wishListUiState.wishlistState = .error("Failed to create wish")
            wishListUiState.errorMessage = "Failed to create wish"
            onFaliure("Failed to create wish")
        }
    }
    
    func deleteWishById(
        id:String,
        onSuccess:()->Void,
        onFaliure:(String)->Void){
        do{
            try repository.deleteWishById(id: id)
            onSuccess()
        } catch {
            wishListUiState.wishlistState = .error("Failed to delete wish")
            wishListUiState.errorMessage = "Failed to delete wish"
            onFaliure("Failed to delete wish")
        }
    }
    
    func deleteAllWish(
        onSuccess:()->Void,
        onFaliure:(String)->Void
    ) {
        do {
            try repository.deleteAll()
            onSuccess()
        } catch {
            onFaliure("Delete failed: \(error)")
        }
    }

    func updateTask(
        wish: WishList,
        onSuccess:()->Void,
        onFaliure:(String)->Void
    ) {
        do {
            try repository.updateWish(wish: wish)
            onSuccess()
        } catch {
            onFaliure("Update failed: \(error)")
        }
    }
    
}
