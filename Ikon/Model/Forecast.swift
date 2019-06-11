//
//  Forecast.swift
//  Lab_6
//
//  Created by Aryan Zaferani-Nobari on 2/18/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation

struct Forecast: Codable
{
    
    let list: [Period]
    
    struct Period: Codable
    {
        let dt: Int
        let main: MainBody
        let weather: [WeatherBody]
        let wind: WindBody
        let snow: SnowBody?
        
        private enum CodingKeys: String, CodingKey
        {
            case dt
            case main
            case weather
            case wind
            case snow
        }
        init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.dt = try container.decode(Int.self, forKey: .dt)
            self.main = try container.decode(MainBody.self, forKey: .main)
            self.weather = try container.decode([WeatherBody].self, forKey: .weather)
            self.wind = try container.decode(WindBody.self, forKey: .wind)
            self.snow = try container.decodeIfPresent(SnowBody.self, forKey: .snow) ?? nil
        }
        
    }
}
struct MainBody: Codable
{
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}

struct WeatherBody: Codable
{
    let description: String
    let icon: String
}

struct WindBody: Codable
{
    let speed: Double
    let deg: Double
}
struct SnowBody: Codable
{
    let oneHour: Double
    let threeHour: Double
    
    private enum CodingKeys : String, CodingKey
    {
        case oneHour = "1h"
        case threeHour = "3h"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.oneHour = try container.decodeIfPresent(Double.self, forKey: .oneHour) ?? 0.0
        self.threeHour = try container.decodeIfPresent(Double.self, forKey: .threeHour) ?? 0.0
    }
}
