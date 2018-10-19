//
//  Location.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/14/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import Foundation

struct Location: Codable {
    let name: String
    let type: String
    let woeid: Int
    let latt_long: String
    let distance: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case type = "location_type"
        case woeid
        case latt_long
        case distance
    }
}
