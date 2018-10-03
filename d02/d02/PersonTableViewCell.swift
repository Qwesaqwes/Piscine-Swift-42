//
//  PersonTableViewCell.swift
//  d02
//
//  Created by Jimmy CHEN-MA on 10/3/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var PersonName: UILabel!
    @IBOutlet weak var PersonDetail: UILabel!
    @IBOutlet weak var PersonDate: UILabel!
    
    var death : (String, String, Date)?
    {
        didSet
        {
            if let d = death
            {
                PersonName?.text = d.0
                PersonDetail?.text = d.1
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM/dd/yyyy"
                PersonDate?.text = dateFormatterPrint.string(from: d.2)
            }
        }
    }

}
