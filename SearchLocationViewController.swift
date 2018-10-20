//
//  SearchLocationViewController.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/20/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationNameInput: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    private var searchResults: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        print("wybrano: \(object.name), woeid: \(object.woeid)")
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
}
