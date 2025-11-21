//
//  UserEntityExtension.swift
//  TorqueNet
//
//  Created by MAC on 21/11/2025.
//
extension UserEntity {
    func toUser() -> User {
        return User(
            uid: self.uid ?? "",
            name: self.name ?? "",
            email: self.email ?? "",
            phoneNumber: self.phoneNumber ?? "",
            profileImageUrl: self.profileImageUrl,
            isSeller: self.isSeller
        )
    }
    
    func toUserEntity(_ user: User) {
        self.uid = user.uid
        self.name = user.name
        self.email = user.email
        self.phoneNumber = user.phoneNumber
        self.profileImageUrl = user.profileImageUrl
        self.isSeller = user.isSeller ?? false
    }
}
