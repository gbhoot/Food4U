//
//  RecipeInfoTblViewExt.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import Foundation
import UIKit

extension RecipeInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return 0 }
        let ingredientList = allRecipes[thisIdx].recipeIngredients!
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx, let cell = tableView.dequeueReusableCell(withIdentifier: ID_REUSE_INGREDIENT_CELL, for: indexPath) as? IngredientCell else { return UITableViewCell() }
        
        let ingredientList = allRecipes[thisIdx].recipeIngredients!
        let ingredient = String(ingredientList[indexPath.row]).prefix(28)
        
        cell.configureCell(index: indexPath.row + 1, ingredient: String(ingredient))
        if ShoppingListService.instance.itemIsInShoppingList(itemName: String(ingredient)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? IngredientCell{
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                ShoppingListService.instance.removeShoppingItem(byItemName: cell.ingredientLbl.text!)
            }else{
                cell.accessoryType = .checkmark
                ShoppingListService.instance.addShoppingItem(itemName: cell.ingredientLbl.text!)
            }
            
        }
    }
}
