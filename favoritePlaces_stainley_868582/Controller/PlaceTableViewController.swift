//
//  PlaceTableViewController.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placesCell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        placesCell.localityLabel.text = places[indexPath.row].locality
        placesCell.postalCodeLabel.text = places[indexPath.row].postalCode
        
        return placesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {(action, view, completionHandler) in
            let alertController = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
           
                     
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                tableView.beginUpdates()
                //Remove contact from DB
                //self.deleteContact(contact: self.filteredContact[indexPath.row])
                //self.saveContact()
                
                //self.filteredContact.remove(at: indexPath.row)
                //self.contacts.remove(at: indexPath.row)
            
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                
                tableView.reloadData()
            }))
            self.present(alertController, animated: true)
            completionHandler(true)
        })
              
        deleteAction.image = UIImage(systemName: "trash")
        
        let  preventSwipe = UISwipeActionsConfiguration(actions: [deleteAction])
        preventSwipe.performsFirstActionWithFullSwipe = false
        
        return preventSwipe
    }
    
    
}