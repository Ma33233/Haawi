//
//  User.swift
//  FinalProject
//
//  Created by Maan Abdullah on 13/09/2022.
//

import Foundation

struct User: Hashable{
    var userID: String
    var userName: String
    var fullName: String?
    var bio: String?
    var followingUsers: [String]?
    var profilePicture: Data?
//    let lan: Double?
//    let long: Double?
}
