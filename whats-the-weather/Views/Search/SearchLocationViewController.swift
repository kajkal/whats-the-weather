//
//  SearchLocationViewController.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/20/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationNameInput: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    private var searchResults: [Location] = []
    private let locationManager: CLLocationManager = CLLocationManager()
    private var currentPlacemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLocationServices()
    }
    
    private func searchResultFetched(locations: [Location]) {
        print("SearchLocationViewController received \(locations.count) search results")
        searchResults = locations
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        let locationName: String = locationNameInput.text ?? ""
        DataFetcher.fetchLocationData(city: locationName, completion: searchResultFetched)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = searchResults[indexPath.row]
        
        print("select: \(object.name), woeid: \(object.woeid)")
        CacheData.getInstance().addWeather(woeid: object.woeid)
        
//        self.navigationController?.popToRootViewController(animated: true)
        performSegue(withIdentifier: "id_segue_backToMaster", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id_cell_searchResultCell", for: indexPath) as! SearchResultTableCell
        let object = searchResults[indexPath.row]
        
        cell.woeid = object.woeid
        cell.locationNameLbl!.text = object.name
        
        return cell
    }
    
    // Location service stuff
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are turned off.")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // yey
            break
        case .denied:
            print("Please enable location services to use this app.")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Somebody has restricted your permission to location services.")
            break
        case .authorizedAlways:
            break
        }
    }
    
    func updateUserLocationDisplayedInfo(placemark: CLPlacemark?) -> Void {
        guard let placemark = placemark else { return }
        
        let city = placemark.subAdministrativeArea ?? ""
        let country = placemark.country ?? ""
        print("User location: \(city), \(country)")
        
        DispatchQueue.main.async {
            if city.isEmpty || country.isEmpty {
                self.currentPlacemark = nil
                self.currentLocationBtn.isEnabled = false
                self.currentLocationBtn.setTitle("no data", for: .normal)
            } else {
                self.currentPlacemark = placemark
                self.currentLocationBtn.isEnabled = true
                self.currentLocationBtn.setTitle("\(city), \(country)", for: .normal)
            }
        }
    }
    
    @IBAction func searchByCurrentLocationBtnClicked(_ sender: UIButton) {
        let coords: CLLocationCoordinate2D = (self.currentPlacemark?.location?.coordinate)!
        let lattlong: String = [coords.latitude, coords.longitude].map{return "\($0)"}.joined(separator: ",")
        print("'\(lattlong)'")
//        DataFetcher.fetchLocationData(city: locationName, completion: searchResultFetched)
    }
}

extension SearchLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location updated: \(location)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                self.updateUserLocationDisplayedInfo(placemark: firstLocation)
            }
            else {
                // An error occurred during geocoding.
                self.updateUserLocationDisplayedInfo(placemark: nil)
            }
        })
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
