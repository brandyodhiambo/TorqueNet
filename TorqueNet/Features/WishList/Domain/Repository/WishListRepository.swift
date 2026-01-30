//
//  WishListRepository.swift
//  TorqueNet
//
//  Created by MAC on 28/01/2026.
//

import Foundation

protocol WishListRepository {
    func createWish(wish: WishList) throws
    func getAll() throws -> [WishList]
    func getWishById(id: String) throws -> WishList?
    func updateWish(wish: WishList) throws
    func deleteWishById(id:String) throws
    func deleteAll() throws
}
