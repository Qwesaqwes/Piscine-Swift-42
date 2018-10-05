//
//  TweetCell.swift
//  d04
//
//  Created by Jimmy CHEN-MA on 10/5/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell
{
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!

    func displayCell(tweet: Tweet) {
        UserNameLabel.text = tweet.name
        DetailLabel.text = tweet.text
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM/dd/yyyy"
        DateLabel?.text = dateFormatterPrint.string(from: tweet.date)
    }
    
//    var tweetcell : Tweet?
//    {
//        didSet
//        {
//            if let d = tweetcell
//            {
//                UserNameLabel.text = d.name
//                DetailLabel.text = d.text
//                let dateFormatterPrint = DateFormatter()
//                dateFormatterPrint.dateFormat = "MMM/dd/yyyy"
//                DateLabel?.text = dateFormatterPrint.string(from: d.date)
//            }
//        }
//    }
}
