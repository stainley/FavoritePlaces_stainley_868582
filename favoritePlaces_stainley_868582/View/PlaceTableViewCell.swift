//
//  PlaceTableViewCell.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var localityLabel: UILabel!
    
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
