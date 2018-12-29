//
//  Recipe.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/17/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class Recipe {
    
    var recipeURI: String?              // URL ID for the recipe (Edamam lookup)
    var recipeName: String?             // Name of the recipe
    var recipeImg: String?              // URL string for recipe image
    var recipeURL: String?              // URL string for the original recipe hosting webpage
    var recipeIngredients: [String]?    // List of recipe ingredients
    var recipeTime: Int?                // Time for total time of the recipe (minutes)
    var recipeServings: Int?            // Number of servings for the recipe
    var recipeCalories: Int?            // Number of calories for the recipe
    
    
    init(name: String, imgURL: String, uri: String, url: String, ingredients: [String], time: Int, servings: Int, calories: Int) {
        recipeName = name
        recipeImg = imgURL
        recipeURI = uri
        recipeURL = url
        recipeIngredients = ingredients
        recipeTime = time
        recipeServings = servings
        recipeCalories = calories
    }
}
