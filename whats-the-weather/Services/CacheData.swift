//
//  CacheData.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

// singleton with cache data fetched from remote services
final class CacheData {
    private static let instance: CacheData = CacheData()
    
    private let weatherIcons: [String: UIImage]
    private var data: [Int: Weather]
    private var refreshFunction: () -> Void
    
    private init() {
        weatherIcons = Dictionary(uniqueKeysWithValues:
            ["c", "h", "hc", "hr", "lc", "lr", "s", "sl", "sn", "t"].map{($0, UIImage(named: $0)!)}
        )
        
        refreshFunction = {() -> Void in print("CacheData.refreshFunction: im not initialized jet!")}
        
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
            refreshFunction()
        } else {
            print("Error: incomplete data!")
        }
    }
    
    // singleton -> get instance
    static func getInstance() -> CacheData {
        return CacheData.instance
    }
    
    // set action to perform after data is changed
    func setRefreshFunction(refreshFunction: @escaping () -> Void) -> Void {
        self.refreshFunction = refreshFunction
    }
    
    // weather icons
    func getWeatherIcon(iconName: String) -> UIImage {
        return weatherIcons[iconName]!
    }
    
    // weather: get
    func getData() -> [Weather] {
        return Array(data.values)
    }
    
    func getDataCount() -> Int {
        return data.count
    }
    
    func getData(index: Int) -> Weather {
        return getData()[index]
    }
    
    func getData(woeid: Int) -> Weather {
        return data[woeid]!
    }
    
    // weather: add
    func addWeather(woeid: Int) -> Void {
        DataFetcher.fetchWeatherData(woeid: woeid, completion: weatherFetched)
    }
    
    // weather: remove
    func removeWeather(index: Int) -> Void {
        removeWeather(woeid: getData()[index].woeid)
    }
    
    func removeWeather(woeid: Int) -> Void {
        data.removeValue(forKey: woeid)
    }
}
