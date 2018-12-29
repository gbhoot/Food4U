//
//  SlideUpSearchTableView.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class SlideUpSearchTableView: UITableView {

   var width  : CGFloat = 0
   var height : CGFloat = 0
   var x      : CGFloat = 0
   var y      : CGFloat = 0
   var cellHeight : CGFloat = 0
   var numCell = 3
    
    var homeDelegate: HomeVCFromSliderUp?
    
    var commonIngredients = ["chicken", "bread", "cheese", "egg", "fish", "beef", "onion", "sugar", "brown sugar", "tomato", "strawberry", "turkey", "pork", "ham", "chicken stock", "raspberry", "mushrooms", "asparagus", "bell pepper", "carrot", "cucumber", "lettuce", "cabbage", "banana", ]
    
    var ingredientSuggestions = [String]()
   
   func setUpFrame(frame: CGRect, searchBarFrame: CGRect){
      self.delegate = self
      self.dataSource = self
      self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      
      self.x      = 0
      self.y      = searchBarFrame.height + 20
      self.height = 200

      self.width  = frame.width
      self.frame  = CGRect(x: x, y: y, width: width, height: height)
      self.alpha  = 0
   }
   
   func slideDown(){
      self.height = (cellHeight+1.5) * CGFloat(numCell )
      self.frame  = CGRect(x: x, y: y, width: width, height: height)
      self.alpha  = 1
   }
   
   func slideUp(){
      self.frame  = CGRect(x: x, y: y, width: width, height: 0)
      self.alpha  = 0
   }
    
    func suggestionsFromSearch(searchStr: String) {
        ingredientSuggestions = [String]()
        commonIngredients.sort()
        if searchStr != "" {
            for single in commonIngredients {
                if single.hasPrefix(searchStr.lowercased()) {
                    print(single)
                    ingredientSuggestions.append(single)
                }
            }
        }
        
        self.reloadData()
    }

}

extension SlideUpSearchTableView : UITableViewDataSource, UITableViewDelegate{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if ingredientSuggestions.count < 3 {
        return numCell
      } else {
        return ingredientSuggestions.count
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cellHeight = cell.frame.height
      if indexPath.row >= ingredientSuggestions.count {
          cell.textLabel?.text = ""
      } else {
          cell.textLabel?.text = ingredientSuggestions[indexPath.row]
      }
      cell.accessoryType   = UITableViewCell.AccessoryType.disclosureIndicator
      cell.selectionStyle = .none
      return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ingredient = ingredientSuggestions[indexPath.row]
        IngredientsDataService.instance.addNewIngredient(ingredientStr: ingredient)
        homeDelegate?.reloadTableData()
    }
}
