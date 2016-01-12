//
//  MapViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import Parse
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var store: PFObject!    // Current Store
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var workingTimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var storeTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.store != nil) {
            
            nameLabel.text = self.storeTitle
            locationLabel.text = self.store["storeAddress"] as? String
            workingTimeLabel.text = self.store["storeTime"] as? String
            
            /**
             * Get store destination and display location on Map
             */
            var destination: PFGeoPoint = PFGeoPoint()
            destination = self.store["storeLocation"] as! PFGeoPoint

            let latDelta: CLLocationDegrees  = 0.01
            let longDelta: CLLocationDegrees = 0.01
            
            let latitude: CLLocationDegrees  = destination.latitude
            let longitude: CLLocationDegrees = destination.longitude
            
            let theSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            
            let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
            
            self.Map.setRegion(theRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = self.store["storeName"] as? String
            
            if (self.nameLabel.text != annotation.title) {
                annotation.subtitle = self.storeTitle
            } else {
                annotation.subtitle = "Магазин техніки"
            }

            self.Map.addAnnotation(annotation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}