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
    func getWishById(id: UUID) throws -> WishList?
    func updateWish(wish: WishList) throws
    func deleteWishById(id:UUID) throws
    func deleteAll() throws
}
