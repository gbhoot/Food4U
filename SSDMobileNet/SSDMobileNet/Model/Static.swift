//
//  Static.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit
import CoreData

let DURATION                    = 0.5
let HOME                        = 0
let SEARCH                      = 1

typealias CompletionHandler     = (_ status: Bool) ->()
typealias CompletionHandRecipe  = (_ status: Bool, _ recipe: Recipe?) ->()
typealias CompletionHandRecipes = (_ status: Bool, _ recipes: [Recipe]) ->()
typealias CompletionHandStrings = (_ status: Bool, _ strings: [String]) ->()
typealias CompletionHandString  = (_ status: Bool, _ str: String) ->()

// Core Data
let appDelegate                         =   UIApplication.shared.delegate as? AppDelegate

// Edamam Service
let URL_EDAMAM_API_RECIPE_SEARCH        =   "https://api.edamam.com/search?"
let API_EDAMAM_APP_ID                   =   "577bd7fb"
let API_EDAMAM_APP_KEY                  =   "4e692325163ba510b9c357038d2136f0"

// Server
let URL_SERVER_INGREDIENTS              =   "http://192.168.0.51:8001/getDirections"
let URL_SERVER_INGREDIENTS_KIM          =   "http://172.20.10.2:8001/getDirections"


// Storyboard IDs
let SB_ID_RECIPE_INFO                   =   "recipeInfoVC"
let SB_ID_RECIPE_DETAIL                 =   "recipeDetailVC"
let SB_ID_SHOPPING_LIST                 =   "shoppingListVC"

// Storyboard Segue IDs
let SB_SEGUE_TO_RECIPE_INFO_VC          =   "toRecipeInfoVC"
let SB_SEGUE_TO_RECIPE_DETAIL_VC        =   "toRecipeDetailVC"
let SB_UNWIND_SEGUE_TO_HOME_VC          =   "unwindToHomeVC"
let SB_UNWIND_SEGUE_TO_INFO_VC          =   "unwindBackToRecipeInfo"

// Custom Cell Reuse IDs
let ID_REUSE_INGREDIENT_CELL            =   "ingredientCell"
let ID_REUSE_LIST_ITEM_CELL             =   "listItemCell"
