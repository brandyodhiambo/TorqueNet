//
//  WishListRepositoryImpl.swift
//  TorqueNet
//
//  Created by MAC on 28/01/2026.
//

import Foundation
import CoreData

class WishListRepositoryImpl: WishListRepository {
    private let context = CoreDataStack.shared.persistentContainer.viewContext
    private let fetchRequest: NSFetchRequest<WishListEntity> = WishListEntity.fetchRequest()

    static let shared = WishListRepositoryImpl()
    
    func createWish(wish:WishList) throws{
        let newWish  = WishListEntity(context: context)
        newWish.id = wish.id
        newWish.title = wish.title
        newWish.image = wish.image
        newWish.currentPrice = wish.currentPrice
        newWish.auctionEndDate = wish.auctionEndDate
        try context.save()
    }
    
    func getAll() throws -> [WishList] {
        let result = try context.fetch(fetchRequest)
        return result.map{WishList.from(entity: $0)}
    }
    
    func getWishById(id: UUID) throws -> WishList? {
        let wishes = try? getAll()
        let wish = wishes?.filter { $0.id == id }.first
        guard let wishUnrwapped = wish else {
            print("No wish found for ID: \(id)")
            return nil
        }
        return wishUnrwapped
    }
    
    func updateWish(wish:WishList) throws{
        fetchRequest.predicate = NSPredicate(format: "id == %@", wish.id as CVarArg)
        guard let wishEntity = try context.fetch(fetchRequest).first else {
            return
        }
        wishEntity.title = wish.title
        wishEntity.image = wish.image
        wishEntity.currentPrice = wish.currentPrice
        wishEntity.auctionEndDate = wish.auctionEndDate
        try context.save( )
    }
    
    func deleteWishById(id:UUID) throws {
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let entity = try context.fetch(fetchRequest).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    func deleteAll() throws {
        let allEntities = try context.fetch(fetchRequest)
        for entity in allEntities {
            context.delete(entity)
        }
        try context.save()
    }



}
