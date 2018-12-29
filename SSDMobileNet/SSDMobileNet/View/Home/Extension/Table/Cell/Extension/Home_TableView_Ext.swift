//
//  Home_TableView_Ext.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
    if currentState == HOME && self.recipeSearch.count > 0 {
        return 2
    }
    
    return 1
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
        return "Recent Search"
    }
    return list[currentState]
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as? MainTblCell else { return UITableViewCell() }
    self.ingredientSearch = IngredientsDataService.instance.returnAllIngredients()
//    if ingredientSearch.count > 0 && currentState == SEARCH {
//        self.loadSearchBarFrame()
//    } else {
//        self.removeSearchBarFromView()
//    }
    if indexPath.section == 1 {
        cell.recipes = recipeSearch
        cell.section = 1
    } else {
        cell.recipes = recipeFavs
        cell.section = 0
    }
      cell.delegate         = self
      cell.currentState     = currentState
//    cell.recipes          = self.recipeFavs
      cell.ingredients      = self.ingredientSearch
      cell.mainCollectView.reloadData()
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 180
   }
}
