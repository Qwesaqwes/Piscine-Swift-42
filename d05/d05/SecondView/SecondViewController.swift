//
//  SecondViewController.swift
//  d05
//
//  Created by Jimmy CHEN-MA on 10/8/18.
//  Copyright © 2018 Jimmy CHEN-MA. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var location = CLLocationManager()
    
    @IBAction func getPositionOfUser(_ sender: UIButton)
    {
        mapView.showsUserLocation = true
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func typeOfMap(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
            case 0:
                mapView.mapType = .standard
                break;
            case 1:
                mapView.mapType = .satellite
                break;
            default:
                mapView.mapType = .hybrid
                break;
        }
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapToCitySelected(latitude:String, longitude:String)
    {
        print(Double(latitude) as Any)
        print(Double(longitude) as Any)
        let newPos = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        let sp = MKCoordinateSpanMake(1, 1)
        let coordinateRegion = MKCoordinateRegion(center: newPos.coordinate,span: sp)
        mapView?.setRegion(coordinateRegion, animated: true)
    }

    func putAnnotation()
    {
        for city in data.citys
        {
            let annotation = MKPointAnnotation()
            annotation.title = city.name
            annotation.subtitle = city.subtitle
            annotation.accessibilityElementsHidden = true
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(city.latitude)!, longitude: Double(city.longitude)!)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
        pinView.canShowCallout = true
        print((annotation.title!)!)
        if (String((annotation.title!)!).compare("école 42").rawValue == 0)
        {
            pinView.pinTintColor = UIColor.green
        }
        if (String((annotation.title!)!).compare("Grand Canarie").rawValue == 0)
        {
            pinView.pinTintColor = UIColor.cyan
        }
        return pinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        putAnnotation()
        self.location.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            location.delegate = self
            location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        let initLocation = CLLocation(latitude: 48.896649, longitude: 2.318350)
        centerMapOnLocation(location: initLocation)
        mapView.isZoomEnabled = true
    }
    
}

