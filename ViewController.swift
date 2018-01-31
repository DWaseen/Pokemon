//
//  ViewController.swift
//  Pokemon
//
//  Created by Dan Waseen on 1/30/18.
//  Copyright © 2018 RevWon. All rights reserv...ed.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("Ready to go")
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //spawn a pokemon
                
                if let coord = self.manager.location?.coordinate {
                    let  anno = MKPointAnnotation()
                    anno.coordinate = coord
                    
                    
                    let randoLat = (Double(arc4random_uniform(200)) - 100.0)/50000
                    let randoLon = (Double(arc4random_uniform(200)) - 100.0)/50000
                    anno.coordinate.latitude += randoLat
                    anno.coordinate.longitude += randoLon
                    
                    
                    self.mapView.addAnnotation(anno)
                }
                
            })
        }
        else{
            manager.requestWhenInUseAuthorization()
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3{
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        }
        else{
            manager.stopUpdatingLocation()
        }
        
    }
    
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
        
    }
}

