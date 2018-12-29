//
//  MainTblCell.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class MainTblCell: UITableViewCell {
   @IBOutlet weak var mainCollectView: UICollectionView!
   
   // Variables
   var list = ["Chicken Mushroom Pie","Chicken Mushroom Pie","Chicken Mushroom Pie","Chicken Mushroom Pie"]
   var delegate : HomeVCProtocol?
    var currentState = HOME
    var recipes = [Recipe]()
    var ingredients = [String]()
    var section: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
      setupTable()
    }
   
   func setupTable() {
      mainCollectView.delegate = self
      mainCollectView.dataSource = self
      mainCollectView.reloadData()
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
