//
//  ViewController.swift
//  rush01
//
//  Created by Quentin ROULON on 10/13/18.
//  Copyright © 2018 Quentin ROULON. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PointAnnotation42: MKPointAnnotation {
    var pinTintColor: UIColor?
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch, UIGestureRecognizerDelegate {

    /************
     * VARIABLES
     ************/
    
    var locationManager: CLLocationManager = CLLocationManager()
    var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    var resultSearchController: UISearchController?
    var userLocation: CLLocationCoordinate2D?
    var directionLocation: CLLocationCoordinate2D?
    var overlay: MKOverlay?
    var timer: Int = 0
    var isChoosen: Bool = false
    var userLocationIsDeparture: Bool = true
    var destinationAnnotation: MKAnnotation?
    var departureAnnotation: MKAnnotation?
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
        }
    }
    @IBOutlet weak var mapStyleButtonOutlet: UISegmentedControl! {
        didSet {
            mapStyleButtonOutlet.layer.cornerRadius = 5
        }
    }
    
    /************
     * ACTIONS
     ************/
    
    @IBAction func centerToLocationButton(_ sender: UIButton) {
        if let currentLocation = locationManager.location {
            mapRegion.center = currentLocation.coordinate
            mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    @IBAction func indexChangeSegmentedButton(_ sender: UISegmentedControl) {
        switch mapStyleButtonOutlet.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard;
        case 1:
            self.mapView.mapType = .satellite;
        default:
            self.mapView.mapType = .hybrid
        }
    }
    
    /************
     * PROTOCOLS
     ************/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            userLocation = location.coordinate
            mapRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(mapRegion, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        if let destination = self.destinationAnnotation {
            mapView.removeAnnotation(destination)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        self.destinationAnnotation = annotation
        
        self.directionLocation = placemark.coordinate
        if let overlay = self.overlay {
            self.mapView.remove(overlay)
            self.isChoosen = false
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        
        if let titleAnnot = annotation.title,
            titleAnnot == "Departure" {
            let reuseId = "departurePin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: self.departureAnnotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.green
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "goto"), for: .normal)
            button.addTarget(self, action: #selector(changeDeparture), for: .touchUpInside)
            
            let buttonDelete = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            buttonDelete.setBackgroundImage(UIImage(named: "trash"), for: .normal)
            buttonDelete.addTarget(self, action: #selector(deleteAnnotation), for: .touchUpInside)
            
            pinView?.rightCalloutAccessoryView = buttonDelete
            pinView?.leftCalloutAccessoryView = button
            return pinView
        } else {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), for: .normal)
            button.addTarget(self, action: #selector(showRouteOnMap), for: .touchUpInside)
            pinView?.rightCalloutAccessoryView = button
            return pinView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let directionLocation = self.directionLocation,
            let _ = self.overlay else { return }
        
        if timer % 5 == 0 && self.isChoosen == true && self.userLocationIsDeparture == true {
            reloadOverlay(departureLocation: userLocation.coordinate, directionLocation: directionLocation)
        }
        timer += 1
    }

    /************
     * FUNCTIONS
     ************/
    
    @objc func reloadOverlay(departureLocation: CLLocationCoordinate2D, directionLocation: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: departureLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: directionLocation, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                if self.overlay != nil {
                    self.mapView.remove(self.overlay!)
                }
                self.overlay = unwrappedResponse.routes[0].polyline
            }
        }
    }
    
    @objc func showRouteOnMap() {
        let request = MKDirectionsRequest()
        userLocation = locationManager.location?.coordinate
        guard let userLocation = self.userLocation, let directionLocation = self.directionLocation else {
            return
        }
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: directionLocation, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                if let _ = self.overlay {
                    self.mapView.remove(self.overlay!)
                }
                self.overlay = unwrappedResponse.routes[0].polyline
                self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                self.isChoosen = true
            }
        }
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began {
            return
        }
        let touchLocation = gestureRecognizer.location(in: self.mapView)
        let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
        
        if self.departureAnnotation != nil {
            self.mapView.removeAnnotation(self.departureAnnotation!)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "Departure"
        
        mapView.addAnnotation(annotation)
        self.departureAnnotation = annotation
        
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
    }
    
    @objc func changeDeparture(locationCoordinate: CLLocationCoordinate2D) {

        self.userLocationIsDeparture = false
        if let destinationAnnotation = self.destinationAnnotation {
            self.userLocation = locationCoordinate
            reloadOverlay(departureLocation: (departureAnnotation?.coordinate)!, directionLocation: destinationAnnotation.coordinate)
        } else {
            
        }
    }
    
    @objc func deleteAnnotation() {
        self.userLocationIsDeparture = false
        mapView.removeAnnotation(self.departureAnnotation!)
        if let _ = self.overlay {
            self.mapView.remove(self.overlay!)
        }
        self.userLocation = locationManager.location?.coordinate
    }
    
    /************
     * OVERRIDES
     ************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.requestLocation()

        mapRegion.span.latitudeDelta = 0.01;
        mapRegion.span.longitudeDelta = 0.01;
        mapView.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as? SearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable?.mapView = mapView
        locationSearchTable?.handleMapSearchDelegate = self
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
}



