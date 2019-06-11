//
//  Resorts.swift
//  Lab_5
//
//  Created by Aryan Zaferani-Nobari on 2/5/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase

class Resorts: NSObject, Codable, MKAnnotation
{
    var id: Int
    var name: String
    var region: String
    var longitude: Double
    var latitude: Double
    var skied: Bool
    var vertical_feet_skied: Int
    var highest_point: Int
    var base: Int
    var time_spent: Double
    var temp : Double
    var lat : [Double]
    var long : [Double]
    var date : Int
    var weather : [Forecast.Period]
    var website : String
    
    
    
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func distanceCalc(long : Double, lat : Double) -> Double
    {
        var distance: Double?
        let x_dist = pow(((self.coordinate.latitude) - lat),2)
        let y_dist = pow(((self.coordinate.longitude) - long),2)
        distance = (x_dist + y_dist).squareRoot()
        return distance!
    }
    
    var title: String?
    {
        return name
    }
    
    var subtitle: String?
    {
        return region
    }
    
    init(id: Int, name: String, region: String,  longitude: Double, latitude: Double, skied: Bool, vertical_feet_skied: Int, highest_point: Int, base: Int, time_spent: Double, temp: Double, lat: [Double], long:[Double], date: Int, weather: [Forecast.Period], website: String)
    {
        self.id = id
        self.name = name
        self.region = region
        self.longitude = longitude
        self.latitude = latitude
        self.skied = skied
        self.vertical_feet_skied = vertical_feet_skied
        self.highest_point = highest_point
        self.time_spent = time_spent
        self.temp = temp
        self.base = base
        self.lat = []
        self.long = []
        self.date = date
        self.weather = []
        self.website = website
    }
    
    
    
    func toAnyObject() -> Any
    {
        return ["id" : id, "name" : name, "region": region, "longitude": longitude, "latitude": latitude,"highest_point" : highest_point, "website": website]
    }
}
