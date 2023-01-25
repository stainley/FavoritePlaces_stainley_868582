//
//  ViewController.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tablePlace: UITableView!
    
    var places: [PlaceEntity] = []
    var place: Place?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablePlace.dataSource = self
        tablePlace.delegate = self
        
        let nib = UINib(nibName: "PlaceTableViewCell", bundle: nil)
        tablePlace.register(nib, forCellReuseIdentifier: "placeCell")
        
        places = loadPlaces()
        tablePlace.reloadData()
        
        tablePlace.rowHeight = UITableView.automaticDimension
        tablePlace.estimatedRowHeight = 200
    }

    override func viewWillAppear(_ animated: Bool) {
        tablePlace.reloadData()
    }
    
    func refreshMyPlaces() {
        places = loadPlaces()
        tablePlace.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeMapSegue"  {
            let placeMapDestination = segue.destination as! MapPlaceViewController
            placeMapDestination.mapDelegate = self

            if let indexPath = tablePlace.indexPathForSelectedRow {
                placeMapDestination.mapDelegate = self
                placeMapDestination.placeEntity = places[indexPath.row]
            }
        }
    }

}

