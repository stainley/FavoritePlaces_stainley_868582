//
//  ViewController.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tablePlace: UITableView!
    
    var places: [Place] = [Place(locality: "Toronto", postalCode: "9988dd")]
    var place: Place?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablePlace.dataSource = self
        tablePlace.delegate = self
        
        let nib = UINib(nibName: "PlaceTableViewCell", bundle: nil)
        tablePlace.register(nib, forCellReuseIdentifier: "placeCell")
    }


}

