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


    /*
    func loadNotes(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<PlaceEntity> = PlaceEntity.fetchRequest()
        let folderPredicate = NSPredicate(format: "parentFolder.name=%@", selectedFolder!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, additionalPredicate])
        } else {
            request.predicate = folderPredicate
        }
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        tableView.reloadData()
    }*/
    
   
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
    
}
