//
//  LocationTableCell.swift
//  whats-the-weather
//
//  Created by mackjkl on 10/19/18.
//  Copyright © 2018 kjkl. All rights reserved.
//

import UIKit

class LocationTableCell: UITableViewCell {
    
    @IBOutlet weak var weatherStateIconImg: UIImageView!
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var tempCurrentLbl: UILabel!
    
    var woeid: Int = -1
    
}
