//
//  DetailViewController.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var locationNameNavItem: UINavigationItem!
    @IBOutlet weak var dateFullLbl: UILabel!
    @IBOutlet weak var dateDayNameLbl: UILabel!
    @IBOutlet weak var weatherStateIconImg: UIImageView!
    @IBOutlet weak var tempMinLbl: UILabel!
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var airPressureLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    private let cacheData: CacheData = CacheData.getInstance()
    private var weather: Weather? = nil
    private var availableRange: (ClosedRange<Int>)?
    private var selectedDay: Int?
    
    func setWeather(weather: Weather) -> Void {
        if weather.days.count > 0 {
            self.weather = weather
            self.availableRange = 0...(weather.days.count - 1)
            self.selectedDay = 0
            
            DispatchQueue.main.async {
                self.locationNameNavItem.title = weather.name.uppercased()
            }
            self.updateViewForSelectedDay()
        } else {
            print("Error: incomplete data!")
        }
    }
    
    func isWeatherNil() -> Bool {
        return weather == nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViewForSelectedDay() {
        if self.availableRange!.contains(self.selectedDay!) {
            DispatchQueue.main.async {
                let data: Weather.Day = (self.weather?.days[self.selectedDay!])!
                
                self.dateFullLbl.text = Formatter.getDateToDisplay(date: data.date)
                self.dateDayNameLbl.text = Formatter.getDayName(date: data.date)
                
                self.weatherStateIconImg.image = self.cacheData.getWeatherIcon(iconName: data.weatherStateImg)
                
                self.tempMinLbl.text = Formatter.getFormattedDouble(d: data.tempMin, type: "t")
                self.tempMaxLbl.text = Formatter.getFormattedDouble(d: data.tempMax, type: "t")
                
                self.windSpeedLbl.text = Formatter.getFormattedDouble(d: data.windSpeed, type: "w")
                self.windDirectionLbl.text = data.windDirection
                
                self.humidityLbl.text = "\(data.humidity)%"
                self.airPressureLbl.text = Formatter.getFormattedDouble(d: data.airPressure, type: "p")
                
                self.backBtn.isEnabled = (1...(self.availableRange!.upperBound)).contains(self.selectedDay!)
                self.nextBtn.isEnabled = (0..<(self.availableRange!.upperBound)).contains(self.selectedDay!)
                
                print("Detail for '\(self.weather!.name)': data for day \(Formatter.getDateToDisplay(date: data.date)) displayed")
            }
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.selectedDay = self.selectedDay! - 1
        self.updateViewForSelectedDay()
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.selectedDay = self.selectedDay! + 1
        self.updateViewForSelectedDay()
    }
    
    // prepare segue to display new view with map
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id_segue_showMap" {
            let lattlong = (self.weather?.lattlong)!
            let controller = segue.destination as! MapViewController
            
            controller.setData(lattlong: lattlong, locationName: (self.weather?.name)!)
        }
    }
}

