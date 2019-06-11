//
//  OtherUsrs.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import MapKit

class OtherUsers : NSObject,Codable, MKAnnotation
{
    var name: String?
    var username: String?
    var pendingFriends = [String]()
    var acceptedFriends = [String]()
    var long: Double?
    var lat: Double?
    var profilepic: String?
    
    init(name: String, username: String, pendingFriends: [String], acceptedFriends: [String],long: Double, lat: Double,  profilepic: String)
    {
        self.name = name
        self.username = username
        self.pendingFriends = pendingFriends
        self.acceptedFriends = acceptedFriends
        self.long = long
        self.lat = lat
        self.profilepic = profilepic
    }
    
    func toAnyObject() -> Any
    {
        username = username?.replacingOccurrences(of: ".", with: ",")
        return ["name" : name ?? "", "username": username ?? "", "pendingFriends" : pendingFriends, "acceptedFriends": acceptedFriends, "long": long ?? 0.0, "lat": lat ?? 0.0, "profilepic": profilepic ?? ""]
    }
    
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: lat!, longitude: long!)
    }
    
    var title: String?
    {
        return name
    }
    
    var subtitle: String?
    {
        return username
    }

}
