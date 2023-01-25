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
    }

    override func viewWillAppear(_ animated: Bool) {
        tablePlace.reloadData()
    }

}

