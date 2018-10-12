//
//  ArticleTableViewCell.swift
//  d09
//
//  Created by Jimmy CHEN-MA on 10/12/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import jichen_m2018

class ArticleTableViewCell: UITableViewCell
{

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var doc: UILabel!
    @IBOutlet weak var dom: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    
    func displayArticle(article:Article)
    {
        title.text = article.title
//        print (article.description)
        detail.text = article.content
        
        let dateFormatterPrint = DateFormatter()
        if (article.dateOfCreation != nil)
        {
            dateFormatterPrint.dateFormat = "'Creation : 'EEEE, MMMM d, yyyy 'at' h:mm:ss a"
            doc.text = dateFormatterPrint.string(from: (article.dateOfCreation)! as Date)
        }

        if (article.dateOfModification != nil)
        {
            dateFormatterPrint.dateFormat = "'Modification : 'EEEE, MMMM d, yyyy 'at' h:mm:ss a"
            dom.text = dateFormatterPrint.string(from: (article.dateOfModification)! as Date)
        }

        if (article.image != nil)
        {
            img.isHidden = false
            imgHeight.constant = 180
            img.contentMode = .scaleAspectFit
            img.image = UIImage(data: article.image! as Data)
        }
        else
        {
            img.isHidden = true
            imgHeight.constant = 0
        }
    }
}
