//
//  Weather.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import Foundation

struct Weather: Codable {
    struct Day: Codable {
        let date: Date
        let weatherStateName: String
        let weatherStateImg: String
        let tempMin: Double
        let tempMax: Double
        let windSpeed: Double
        let windDirection: String
        let humidity: Int
        let airPressure: Double
        
        enum CodingKeys: String, CodingKey {
            case date = "applicable_date"
            case weatherStateName = "weather_state_name"
            case weatherStateImg = "weather_state_abbr"
            case tempMin = "min_temp"
            case tempMax = "max_temp"
            case windSpeed = "wind_speed"
            case windDirection = "wind_direction_compass"
            case humidity
            case airPressure = "air_pressure"
        }
    }
    
    let woeid: Int
    let name: String
    let days: [Day]
    
    enum CodingKeys: String, CodingKey {
        case days = "consolidated_weather"
        case name = "title"
        case woeid
    }
}
