//
//  ViewController.swift
//  Pokemon
//
//  Created by Dan Waseen on 1/30/18.
//  Copyright © 2018 RevWon. All rights reserv...ed.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var updateCount = 0
    
    var pokemons : [Pokemon] = []
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUp()
        }
        else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status  == .authorizedWhenInUse {
           setUp()
        }
    }
    
    
    func setUp() {
        
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //spawn a pokemon
            
            if let coord = self.manager.location?.coordinate {
                
                let pok_cnt =  UInt32((self.pokemons.count))
                
                let poke_idx = Int(arc4random_uniform(pok_cnt))
                
                let pokemon = self.pokemons[poke_idx]
                
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                
                let randoLat = (Double(arc4random_uniform(200)) - 100.0)/50000
                let randoLon = (Double(arc4random_uniform(200)) - 100.0)/50000
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                
                
                self.mapView.addAnnotation(anno)
            }
            
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            var frame = annoView.frame
            frame.size.height  = 50
            frame.size.width = 50
            annoView.frame = frame
            return annoView
        }
        
        let  annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon  = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)
        var frame = annoView.frame
        frame.size.height  = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
        
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation!, animated: true)
        if view.annotation! is MKUserLocation{
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            
            if let coord = self.manager.location?.coordinate
            {
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if  MKMapRectContainsPoint(mapView.visibleMapRect,MKMapPointForCoordinate(coord))
                {
                    pokemon.caught = true

                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught the \(pokemon.name!) ", preferredStyle: .alert)
                    
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: {(action) in
                        
                       self.performSegue(withIdentifier: "pokeSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                else
                {
                    let alertVC = UIAlertController(title: "Oh - Oh", message: "You are too far away to catch the \(pokemon.name!).  Move closer to it ", preferredStyle: .alert)
                    let OKaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKaction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
            
        })
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate{
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
        
    }
}

