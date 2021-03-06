
//
//  CoreDataHelp.swifft.swift
//  Pokemon
//
//  Created by Dan Waseen on 1/31/18.
//  Copyright © 2018 RevWon. All rights reserved.
//

import UIKit
import CoreData


func addAllPokemon() {
    
    createPokemon(name : "Mew", imageName: "mew")
    createPokemon(name : "Meoth", imageName: "meowth")
    
    createPokemon(name : "Mankey", imageName: "mankey")
    createPokemon(name : "Pidgey", imageName: "pidgey")
    
    createPokemon(name : "Pikachu", imageName: "pikachu")
    createPokemon(name : "Rattata", imageName: "rattata")
    
    createPokemon(name : "Eevee", imageName: "eevee")
    createPokemon(name : "Snorlax", imageName: "snorlax")
    
    createPokemon(name : "Weedle", imageName: "weedle")
    createPokemon(name : "Zubat", imageName: "zubat")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name : String, imageName: String){
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
    
}

func getAllPokemon() -> [Pokemon]  {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let pokemons =  try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        return pokemons
    }catch {
        
    }
    
    return []
}

func getAllCaughtPokemons() -> [Pokemon]{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true  as CVarArg)
    
    do {
        let pokemons =  try context.fetch(fetchRequest) as! [Pokemon]
        return pokemons
    }catch{}
    return[]
    
}

func getAllUnCaughtPokemons() -> [Pokemon]{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false  as CVarArg)
    
    do {
        let pokemons =  try context.fetch(fetchRequest) as! [Pokemon]
        return pokemons
    }catch{}
    return[]
    
}


