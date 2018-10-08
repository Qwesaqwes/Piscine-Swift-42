//
//  MessageTableViewCell.swift
//  rush00
//
//  Created by Quentin ROULON on 10/6/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nbRepliesLabel: UILabel!
    var replies: [Message]!
    
    func displayMessage(message: Message) {
        messageLabel.text = message.content
        authorLabel.text = message.author.login
        nbRepliesLabel.text = String(message.replies.count)
        replies = message.replies
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: message.created_at)
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateLabel.text = formatter.string(for: date)
        
    }
    
    func messageIsMine(isMine: Bool) {
        if isMine {
            self.backgroundColor = UIColorFromHex(rgbValue: 0xd3f4d7, alpha: 1)
        } else {
            self.backgroundColor = UIColor.white
        }
        
    }
    
    private func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
