//
//  Weather.swift
//  Lab_6
//
//  Created by Aryan Zaferani-Nobari on 2/16/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation

class Weather: Codable
{
    var dateAndTime: String
    var conditions: String
    var highTemp: Double
    var lowTemp: Double
    var windSpeed: Double
    var windDirection: Double
    var humidity: Int
    var iconID: String
    var snow: Double
    
    init(dateAndTimeAsUnixTime: Int, conditions: String, highTemp: Double, lowTemp: Double, windSpeed: Double, windDirection: Double, humidity: Int, iconID: String, snow: Double)
    {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        dateAndTime = df.string(from: Date(timeIntervalSince1970: Double(dateAndTimeAsUnixTime)))
        self.conditions = conditions
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.humidity = humidity
        self.iconID = iconID
        self.snow = snow
    }
}
