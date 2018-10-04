//
//  ViewController.swift
//  d03
//
//  Created by Jimmy CHEN-MA on 10/4/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var CollectionView: UICollectionView!
    var nbOfImageLoaded:Int = 0
    var i:UIImage!
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return DataURL.ImagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NasaCell", for: indexPath) as! NasaCollectionViewCell
        cell.contentView.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 0.66)
        
        if let imageFromCache = imageCache.object(forKey: DataURL.ImagesURL[indexPath.item] as AnyObject)
        {
            cell.Image.image = imageFromCache as? UIImage
        }
        else
        {
            /*Activity Monitor*/
            var activityView:UIActivityIndicatorView = UIActivityIndicatorView()
            activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityView.hidesWhenStopped = true
            activityView.center = cell.contentView.center
            cell.Image.addSubview(activityView)
            activityView.startAnimating()
            
            /*Set Network Activity visible*/
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            /*Loaded image in a Async way*/
            let url = URL(string: DataURL.ImagesURL[indexPath.item])
            DispatchQueue.global(qos:DispatchQoS.background.qosClass).async
            {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async
                {
                    print (indexPath.item)
                    
                    activityView.stopAnimating()
                    var imageToCache = UIImage(data: data!)
                    
                    /*Check if failed to load image*/
                    let res:UIImage? = imageToCache
                    if (res == nil)
                    {
                        let alert = UIAlertController(title: "Error", message: "Failed to load image.", preferredStyle:UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        imageToCache = UIImage(named: "ImageNotFound")
                    }
                    
                    /*If it is the last Image to load set Visibility to false for the Network Activity*/
                    if (self.nbOfImageLoaded == DataURL.ImagesURL.count - 1)
                    {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    self.nbOfImageLoaded = self.nbOfImageLoaded + 1
                    
                    self.imageCache.setObject(imageToCache!, forKey: DataURL.ImagesURL[indexPath.item] as AnyObject)
                    cell.Image.image = imageToCache
                }
            }
        }
        return cell
    }
    
    /* Set Properties of destination ViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "SegueForImage")
        {
            if let vc = segue.destination as? SecondViewController
            {
                if let cell = sender as? NasaCollectionViewCell
                {
                    vc.ImageSelected = cell.Image.image
                }
            }
        }
    }
}

