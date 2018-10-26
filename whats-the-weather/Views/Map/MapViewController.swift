//
//  MapViewController.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/26/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var locationNameNavItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    
    private var coordinate: [Double] = [50.064528, 19.923556] // default coords
    private var locationName: String = "location name"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.coordinate[0], longitude: self.coordinate[1])
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.locationName
        
        DispatchQueue.main.async {
            self.locationNameNavItem.title = self.locationName.uppercased()
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func setData(lattlong: String, locationName: String) -> Void {
        self.coordinate = lattlong.split(separator: ",").map{return Double($0)!}
        self.locationName = locationName
        print("Coordinate set to <\(self.coordinate[0], self.coordinate[1])> \(locationName)")
    }
}
