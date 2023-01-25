//
//  PlaceRepository.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit
import CoreData

extension MapPlaceViewController {
    
    /// Save place into core data
    func savePlace() {
        do {
            try context.save()
        } catch {
            print("Error saving the notes \(error.localizedDescription)")
        }
    }


    
    
   
}


extension ViewController {
    func  loadPlaces() -> [PlaceEntity] {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        
        do {
            return  try context.fetch(request)
        } catch {
            print("Error loading contacts \(error.localizedDescription)")
        }
        return []
    }
    
    func deletePlace(place: PlaceEntity) {
        context.delete(place)
    }
    
    func savePlace() {
        do {
            try context.save()
        } catch {
            print("Error saving the notes \(error.localizedDescription)")
        }
    }
    
    // Update Place
    func updatePlace(with place: PlaceEntity) {
        savePlace()
    }
    
}
