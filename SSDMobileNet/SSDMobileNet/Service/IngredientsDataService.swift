//
//  IngredientsDataService.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/20/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class IngredientsDataService {
    
    static let instance = IngredientsDataService()
    
    // Variables
    private var ingredients = [String]()
    
    func addNewIngredient(ingredientStr: String) {
        if !ingredientIsInList(ingredientStr: ingredientStr) {
            ingredients.append(ingredientStr)
        }
    }
    
    func ingredientIsInList(ingredientStr: String) -> Bool {
        for ingredient in ingredients {
            if ingredient == ingredientStr {
                return true
            }
        }
        
        return false
    }
    
    func removeAllSpacesFromIngredients() {
        var count = 0
        for ingredient in ingredients {
            ingredients[count] = ingredient.replacingOccurrences(of: " ", with: "-")
//            let parts = ingredient.split(separator: " ")
//            let newPart = parts[0] + parts[1]
//            ingredients[count] = String(newPart)
            count += 1
        }
    }
    
    func removeIngredient(byIndex idx: Int) {
        ingredients.remove(at: idx)
    }
    
    func removeIngredient(byIngredientName name: String) {
        var count = 0
        for ingredient in ingredients {
            if ingredient == name {
                ingredients.remove(at: count)
                return
            } else {
                count += 1
            }
        }
    }
    
    func removeAllIngredients() {
        self.ingredients = [String]()
    }
    
    func returnAllIngredients() -> [String] {
        return ingredients
    }
}
