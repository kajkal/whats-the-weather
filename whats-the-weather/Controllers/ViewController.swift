//
//  ViewController.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/14/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var dataFullLbl: UILabel!
    @IBOutlet weak var dataDayNameLbl: UILabel!
    @IBOutlet weak var weatherStateIconImg: UIImageView!
    @IBOutlet weak var tempMinLbl: UILabel!
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var airPressureLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    private let weatherIcons: [String: UIImage] = {
        var icons = [String: UIImage]()
        for iconName in ["c", "h", "hc", "hr", "lc", "lr", "s", "sl", "sn", "t"] {
            icons[iconName] = UIImage(named: iconName)!
        }
        print("weather icons loaded")
        return icons
    }()
    
    private var weather: Weather?
    private var availableRange: (ClosedRange<Int>)?
    private var selectedDay: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DataFetcher.fetchWeatherData(woeid: 523920, completion: weatherFetched)
    }
    
    private func weatherFetched(weather: Weather) {
        print("UI received weather record with \(weather.days.count) days for '\(weather.name)'")
        for d in weather.days {
            print(d)
        }
        
        if (weather.days.count > 0) {
            self.weather = weather
            self.availableRange = 0...(weather.days.count - 1)
            self.selectedDay = 0
            
            DispatchQueue.main.async {
                self.locationNameLbl.text = weather.name.uppercased()
            }
            self.updateViewForSelectedDay()
        } else {
            print("Error: incomplete data!")
        }
    }
    
    private func updateViewForSelectedDay() {
        if self.availableRange!.contains(self.selectedDay!) {
            DispatchQueue.main.async {
                let data: Weather.Day = (self.weather?.days[self.selectedDay!])!
                
                self.dataFullLbl.text = Formatter.getDateToDisplay(date: data.date)
                self.dataDayNameLbl.text = Formatter.getDayName(date: data.date)
                
                self.weatherStateIconImg.image = self.weatherIcons[data.weatherStateImg]
                
                self.tempMinLbl.text = Formatter.getFormattedDouble(d: data.tempMin, type: "t")
                self.tempMaxLbl.text = Formatter.getFormattedDouble(d: data.tempMax, type: "t")
                
                self.windSpeedLbl.text = Formatter.getFormattedDouble(d: data.windSpeed, type: "w")
                self.windDirectionLbl.text = data.windDirection
                
                self.humidityLbl.text = "\(data.humidity)%"
                self.airPressureLbl.text = Formatter.getFormattedDouble(d: data.airPressure, type: "p")
                
                self.backBtn.isEnabled = (1...(self.availableRange!.upperBound)).contains(self.selectedDay!)
                self.nextBtn.isEnabled = (0..<(self.availableRange!.upperBound)).contains(self.selectedDay!)
                
                print("data for day \(Formatter.getDateToDisplay(date: data.date)) displayed")
            }
        }
    }

    @IBAction func backBtnClicked(_ sender: UIButton) {
        print("back button clicked!")
        self.selectedDay = self.selectedDay! - 1
        self.updateViewForSelectedDay()
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        print("next button clicked!")
        self.selectedDay = self.selectedDay! + 1
        self.updateViewForSelectedDay()
    }
}

