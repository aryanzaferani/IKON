//
//  User.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import UIKit

final class User:Codable
{
    static var myUser = User()
    var name: String?
    var userResorts = [Resorts]()
    var username: String?
    var pendingFriends = [String]()
    var acceptedFriends = [String]()
    var long: Double?
    var lat: Double?
    var visitedResorts = [Resorts]()
    var profilepic: String?
    init(){}
    
    func toAnyObject() -> Any
    {
        username = username?.replacingOccurrences(of: ".", with: ",")
        profilepic = profilepic?.replacingOccurrences(of: ".", with: ",")
        return ["name" : name ?? "", "username": username ?? "", "pendingFriends" : pendingFriends, "acceptedFriends": acceptedFriends, "long": long ?? 0.0, "lat": lat ?? 0.0, "profilepic" : profilepic ?? "NA" ]
    }

}

