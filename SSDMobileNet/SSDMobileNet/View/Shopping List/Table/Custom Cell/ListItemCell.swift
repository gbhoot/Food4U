//
//  ListItemCell.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var indexLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(index: Int, itemName: String) {
        indexLbl.text = "\(index)"
        itemNameLbl.text = itemName
    }

}
