//
//  DataFetcher.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import Foundation

class DataFetcher {
    static let baseURL: URL? = URL(string: "https://www.metaweather.com/api/location/")
    
    // eg DataFetcher.fetchLocationData(city: "warsaw", completion: locationFetched)
    static func fetchLocationData(city: String, completion: @escaping ([Location]) -> Void) {
        guard let url = URL(string: "search/?query=\(city.lowercased())", relativeTo: baseURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Response error")
            }
            
            guard let dataResponse = data else {return}
            do {
                let decoder = JSONDecoder()
                let jsonResponse = try decoder.decode([Location].self, from: dataResponse)
                
                print("fetchLocationData received: \(jsonResponse.count)")
                
                completion(jsonResponse)
            } catch let parsingError {
                print(parsingError.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func fetchLocationData(lattlong: String, completion: @escaping ([Location]) -> Void) {
        guard let url = URL(string: "search/?lattlong=\(lattlong)", relativeTo: baseURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Response error")
            }
            
            guard let dataResponse = data else {return}
            do {
                let decoder = JSONDecoder()
                let jsonResponse = try decoder.decode([Location].self, from: dataResponse)
                
                print("fetchLocationData received: \(jsonResponse.count)")
                
                completion(jsonResponse)
            } catch let parsingError {
                print(parsingError.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func fetchWeatherData(woeid: Int, completion: @escaping (Weather) -> Void) {
        guard let url = URL(string: String(woeid), relativeTo: baseURL) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Response error")
            }
            
            guard let dataResponse = data else {return}
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Formatter.basicDateFormatter)
                let jsonResponse = try decoder.decode(Weather.self, from: dataResponse)
                
                print("fetchWeatherData received data")
                
                completion(jsonResponse)
            } catch let parsingError {
                print(parsingError.localizedDescription)
            }
        }
        task.resume()
    }
}
