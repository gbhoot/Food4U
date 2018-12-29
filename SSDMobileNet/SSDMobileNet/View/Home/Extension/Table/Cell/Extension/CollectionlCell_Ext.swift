//
//  MainTblCell_Ext.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import Foundation
import  UIKit


extension MainTblCell: UICollectionViewDelegate, UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if currentState == HOME {
        return recipes.count
    } else {
        return ingredients.count
    }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCollectCell", for: indexPath) as? MainCollectCell else { return UICollectionViewCell() }
   
    if currentState == HOME {
        cell.configureCell(title: recipes[indexPath.row].recipeName!, image: recipes[indexPath.row].recipeImg!, currentState: currentState)
    } else {
        cell.configureCell(title: ingredients[indexPath.row], image: nil, currentState: currentState)
    }
    cell.section = self.section
    
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if currentState == HOME {
        
        delegate?.showRecipeDetail(index: indexPath.row, section: self.section!)
    } else {
        return
    }
   }
}

//***********************RESIZE*************************************

extension MainTblCell : UICollectionViewDelegateFlowLayout{
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let num : CGFloat = 3
      let yourWidth = (collectionView.bounds.width - 10 * (num - 1 ) ) / 3.0
      let yourHeight = (collectionView.bounds.height)
      
      return CGSize(width: yourWidth, height: yourHeight)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets.zero
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 10
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 10
   }
}
