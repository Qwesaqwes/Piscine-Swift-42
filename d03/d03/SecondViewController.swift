//
//  SecondViewController.swift
//  d03
//
//  Created by Jimmy CHEN-MA on 10/4/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIScrollViewDelegate
{
    var ImageSelected : UIImage!
    var imageView : UIImageView?
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!


    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1)
        ScrollView.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1)
        imageView = UIImageView(image:ImageSelected)
        ScrollView.addSubview(imageView!)
        ScrollView.contentSize = (imageView?.frame.size)!
       
        /* Set Zoom and Dezoom */
        let widthScale = self.view.frame.width / (imageView?.bounds.width)!
        let heightScale = 100.0
        let minScale = min(widthScale, CGFloat(heightScale))
        ScrollView.minimumZoomScale = minScale
        ScrollView.zoomScale = minScale
        
//        /* Center Image */
//        let yOffset = max(0, (self.view.frame.height - (imageView?.frame.height)!) / 2)
//        imageViewTopConstraint.constant = yOffset
//        imageViewBottomConstraint.constant = yOffset
//
//        let xOffset = max(0, (self.view.frame.width - (imageView?.frame.width)!) / 2)
//        imageViewLeadingConstraint.constant = xOffset
//        imageViewTrailingConstraint.constant = xOffset
//        
//        view.layoutIfNeeded()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {
        let widthScale = self.view.frame.width / (imageView?.bounds.width)!
        let heightScale = 100.0
        let minScale = min(widthScale, CGFloat(heightScale))
        ScrollView.minimumZoomScale = minScale
        ScrollView.zoomScale = minScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
}
