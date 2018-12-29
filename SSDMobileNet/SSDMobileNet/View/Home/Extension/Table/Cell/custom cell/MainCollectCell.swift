//
//  MainCollectCell.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class MainCollectCell: UICollectionViewCell {
   @IBOutlet weak var image: UIImageView!
   @IBOutlet weak var cellLabel: UILabel!
   var delegate : HomeVCProtocol?
    var section: Int?
   
   func configureCell(title: String, image: String?, currentState: Int) {
      cellLabel.text = title.capitalized
    if currentState == HOME {
        self.image.downloaded(from: image!)
    } else {
        if title == "banana" {
            self.image.loadGif(name: "brianBanana")
        } else {
            self.image.image = UIImage(named: title)
        }
    }
   }
}
