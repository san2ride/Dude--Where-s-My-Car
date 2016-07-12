//
//  ViewController.swift
//  DudeCar
//
//  Created by don't touch me on 7/11/16.
//  Copyright © 2016 trvl, LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var locoArray = [CurrentLocation]()
    var currentPosition: CurrentLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    @IBAction func addButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Current Location", message: "Add Location", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Current Location",
                                       style: .Default,
                                       handler: {
                                        (action) in
                                        
                                        self.currentPosition = CurrentLocation()
                                        
                                        if let textField = alert.textFields?.first {
                                            
                                            if let name = textField.text {
                                                print(name)
                                                
                                                self.currentPosition?.name = name
                                                
                                            }
                                        }
                                        
                                        if let zipTextField = alert.textFields? [1] {
                                            
                                            if let zipcode = zipTextField.text {
                                                print(zipcode)
                                                
                                                self.currentPosition?.zipcode = zipcode
                                                
                                                self.geocoding(zipcode, completion: {
                                                    (latitude, longitude) in
                                                    
                                                    self.currentPosition?.latitude = latitude
                                                    self.currentPosition?.longitude = longitude
                                                    
                                                    print(latitude)
                                                    print(longitude)
                                                    
                                                    if let current = self.currentPosition {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), {
                                                            self.locoArray.append(current)
                                                            
                                                        })
                                                    }
                                                    
                                                    
                                                })
                                            }
                                        }
                                        
                                        
        })
        
        alert.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) {
                                            (action) in
    }
    
    alert.addAction(cancelAction)
    
    
    // Add a textfield to the AlertController
    
    alert.addTextFieldWithConfigurationHandler {
    (textField) in
    
    // configure the placeholder text
    textField.placeholder = "enter desired city"
    }
    
    
    alert.addTextFieldWithConfigurationHandler {
    (textField) in
    
    // configure the placeholder text
    textField.placeholder = "zipcode"
    }
    
    // Present the alert using presentViewController
    self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    func geocoding(location: String, completion: (Double, Double) -> ()) {
        CLGeocoder().geocodeAddressString(location) {
            
            (placemarks, error) in
            
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark!.location
                let coordinate = location?.coordinate
                completion((coordinate?.latitude)!, (coordinate?.longitude)!)
            }
        }
    
    }

}