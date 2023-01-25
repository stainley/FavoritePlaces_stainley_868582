//
//  Place.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import Foundation

struct Place {
    private (set) var locality: String?
    private (set) var postalCode: String?
    
    init(locality: String? = nil, postalCode: String? = nil) {
        self.locality = locality
        self.postalCode = postalCode
    }
}
