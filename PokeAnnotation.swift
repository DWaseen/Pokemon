//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by Dan Waseen on 1/31/18.
//  Copyright © 2018 RevWon. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon){
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

