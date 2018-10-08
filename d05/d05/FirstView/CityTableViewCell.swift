//
//  CityTableViewCell.swift
//  d05
//
//  Created by Jimmy CHEN-MA on 10/8/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell
{
    @IBOutlet weak var cityLabel: UILabel!
    var longitude:String = ""
    var latitude:String = ""
    var subtitle:String = ""
    
    
    var city: (String, String, String, String)?
    {
        didSet
        {
            if let d = city
            {
                cityLabel.text = d.0
                longitude = d.2
                latitude = d.1
                subtitle = d.3
            }
        }
    }
}
