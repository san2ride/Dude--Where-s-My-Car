//
//  ViewController.swift
//  DudeCar2
//
//  Created by don't touch me on 7/11/16.
//  Copyright © 2016 trvl, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var locoView: MKMapView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPin(40.725895, longitude: -111.552574, title: "Nuzzles Co", subtitle: "435.649.5441")
        self.addPin(40.732895, longitude: -111.383897, title: "Rescue Ranch", subtitle: "435.649.5441")
        self.addPin(40.654737, longitude: -111.504550, title: "Home Sweet Home", subtitle: "Powder Keg Condo's")
        
        let latitude = (40.732895 + 40.730459 + 40.654737) / 3
        let longitude = (-111.551152 + -111.383897 + -111.504550) / 3
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.saveButton()
        self.centerMap(location)
    }
    
    @IBAction func saveButton() {
    
        let status = CLAuthorizationStatus.AuthorizedWhenInUse
        
        if status != .Denied {
            self.locoView.showsUserLocation = true
            self.locationManager.requestLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        self.saveButton()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.first
            print(location?.coordinate.latitude)
            print(location?.coordinate.longitude)
        }
    }
    
    func centerMap(centerCoordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta:  0.6)
        
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        self.locoView.setRegion(region, animated: true)
        
        
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func addPin(latitude: Double, longitude: Double, title: String, subtitle: String) {
        
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        
        self.locoView.addAnnotation(annotation)
        
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPinIdentifier"
        
        
        // ensure annotation
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            // pin color
            annotationView?.pinTintColor = UIColor.orangeColor()
            
            // Ensure proper use of identifier
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // show Callout (true/false)
            annotationView?.canShowCallout = true
            
            let leftIconView = UIImageView(frame: CGRectMake(0, 0, 27, 30))
            leftIconView.image = UIImage(named: "apple")
            annotationView?.leftCalloutAccessoryView = leftIconView
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }



}

