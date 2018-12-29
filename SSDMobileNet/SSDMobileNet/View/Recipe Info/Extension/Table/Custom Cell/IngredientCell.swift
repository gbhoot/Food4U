//
//  IngredientCell.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var ingredientLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(index: Int, ingredient: String) {
        indexLbl.text = "\(index)"
        ingredientLbl.text = ingredient
    }
}
