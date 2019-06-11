//
//  SkiMapResorts.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation

struct SkiMapResorts: Codable
{
    struct SkiRegion: Codable
    {
        let SkiArea: SkiArea
        let Region: [Region]
    }
    struct SkiArea: Codable
    {
        let id: String?
        let name: String?
        let official_website: String?
        let geo_lat: String?
        let geo_lng: String?
        let top_elevation: String?
        let bottom_elevation: String?
        let vertical_drop: String?
        let operating_status: String?
        let has_downhill: Bool?
        let has_nordic: Bool?
        
    }
    struct Region: Codable
    {
        let name: String?
        let id: String?
        var RegionsSkiArea :  RegionsSkiArea?
        
    }
    struct RegionsSkiArea: Codable
    {
        let id : String?
        let ski_area_id: String?
        let region_id: String?
        let temp_region: String?
        let temp_country: String?
    }
}
