//
//  ViewController.swift
//  d06
//
//  Created by Jimmy CHEN-MA on 10/9/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let gravityBehavior = UIGravityBehavior()
    var dynamicAnimator: UIDynamicAnimator!
    var collision = UICollisionBehavior()
    var elasticity = UIDynamicItemBehavior()
    var formView:FormsView?
    
    static var indexTag:Int = 1
    
    var magnitude:CGFloat = 1
    var elastic:CGFloat = 0.5
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
        let locTap = sender.location(in: view)
        formView = FormsView(frame: CGRect(x: locTap.x - 50, y: locTap.y - 50, width: 100, height: 100))
        formView?.tag = ViewController.indexTag
//        print (formView?.tag as Any)
        self.view.addSubview(formView!)
        
        gravityBehavior.addItem(formView!)
        collision.addItem(formView!)
        elasticity.addItem(formView!)
        ViewController.indexTag = ViewController.indexTag + 1
    }
    
    @IBAction func dragGesture(_ sender: UIPanGestureRecognizer)
    {
ls
        
        if let k = formView
        {
//            self.view.bringSubview(toFront: k)
//            let translation = sender.translation(in: k)
//            k.center = CGPoint(x: k.center.x + translation.x, y: k.center.y + translation.y)
//            sender.setTranslation(CGPoint.zero, in: self.view)
            let location =  sender.location(in: view)
            k.drag(loc:location)
//            k.position
            
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior.magnitude = magnitude
        elasticity.elasticity = elastic
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(collision)
        dynamicAnimator.addBehavior(elasticity)
        collision.translatesReferenceBoundsIntoBoundary = true
    }
}

