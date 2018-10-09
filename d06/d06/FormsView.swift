//
//  FormsView.swift
//  d06
//
//  Created by Jimmy CHEN-MA on 10/9/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class FormsView: UIView
{
    var randomNumber:Bool = false
    
    override public var collisionBoundsType: UIDynamicItemCollisionBoundsType
    {
        return (randomNumber) ? .ellipse : .rectangle
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), green:CGFloat(Float(arc4random()) / Float(UINT32_MAX)), blue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), alpha:1)

        randomNumber = Int(arc4random_uniform(2)) == 0 ? true: false
        if (randomNumber)
        {
            //draw cercle
            self.layer.cornerRadius = self.frame.width / 2
            self.clipsToBounds = true
        }
    }
    
    func drag(loc:CGPoint)
    {
        self.frame = self.frame.offsetBy(dx: loc.x, dy: loc.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
