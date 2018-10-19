//
//  CacheData.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

// singleton with cache data fetched from remote services
class CacheData {
    private static let instance: CacheData = CacheData()
    private let weatherIcons: [String: UIImage]
    private var data: [Int: Weather]
    
    private init() {
        weatherIcons = {
            let iconNames: [String] = ["c", "h", "hc", "hr", "lc", "lr", "s", "sl", "sn", "t"]
            var icons = [String: UIImage]()
            for iconName in iconNames {
                icons[iconName] = UIImage(named: iconName)
            }
            return icons
        }()
        
        data = [Int: Weather]()
        addWeather(woeid: 523920) // Warsaw
        addWeather(woeid: 554890) // Copenhagen
        addWeather(woeid: 924938) // Kiev
        
        print("CacheData singleton initialized")
    }
    
    private func weatherFetched(weather: Weather) -> Void {
        print("CacheData received weather record with \(weather.days.count) days for '\(weather.name)'")
        
        if weather.days.count > 0 {
            data[weather.woeid] = weather
        } else {
            print("Error: incomplete data!")
        }
    }
    
    static func getInstance() -> CacheData {
        return CacheData.instance
    }
    
    func addWeather(woeid: Int) -> Void {
        DataFetcher.fetchWeatherData(woeid: woeid, completion: weatherFetched)
    }
    
    func getData() -> [Weather] {
        return Array(data.values)
    }
}
