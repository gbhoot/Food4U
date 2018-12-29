//
//  EdamamService.swift
//  foody4U
//
//  Created by Gurpal Bhoot on 11/11/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit

class EdamamService {
    
    static let instance = EdamamService()
    
    var jsonResults: NSDictionary?
    var foundAll = false
    
    // Functions    
    func getRecipeList(withIngredients ingredients: [String], completion: @escaping CompletionHandRecipes) {
        var recipes = [Recipe]()
        
        var ingredientsStr = "&q="
        for ingredient in ingredients {
            ingredientsStr += "$" + ingredient
        }
        let urlStr = URL_EDAMAM_API_RECIPE_SEARCH + "&app_id=" + API_EDAMAM_APP_ID + "&app_key=" + API_EDAMAM_APP_KEY + ingredientsStr
        
        print(urlStr)
        
        let url = URL(string: urlStr)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            guard let retrievedData = data else {
                print(error?.localizedDescription)
                return
            }
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: retrievedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else { return }
                let listOfRecipes = jsonData["hits"] as? NSArray
                for recipeSingle in listOfRecipes! {
                    let recipeDict = recipeSingle as? [String: Any]
                    guard let recipe = recipeDict!["recipe"] as? [String: Any] else { return }
                    let recipeName = recipe["label"] as! String
                    let recipeImg = recipe["image"] as! String
                    var recipeURI = recipe["uri"] as! String
                    let recipeURL = recipe["url"] as! String
                    let recipeIngredients = recipe["ingredientLines"] as! [String]
                    let time = recipe["totalTime"] as! Int
                    let servings = recipe["yield"] as! Int
                    let calories = recipe["calories"] as! Double
                    let caloriesInt = Int(calories)
                    recipeURI = self.configureRecipeURL(urlStr: recipeURI)
                    let newRecipe = Recipe(name: recipeName, imgURL: recipeImg, uri: recipeURI, url: recipeURL, ingredients: recipeIngredients, time: time, servings: servings, calories: caloriesInt)
                    recipes.append(newRecipe)
                }
                completion(true, recipes)
            } catch {
                print("Can't do get request: \(error), \(error.localizedDescription)")
                recipes = [Recipe]()
                completion(false, recipes)
            }
        }
        
        task.resume()
    }
    
    func getSingleRecipeDetails(withURI uri: String, completion: @escaping CompletionHandRecipe) {
        let recipeURI = "&r=" + configureRecipeURL(urlStr: uri)
        let urlStr = URL_EDAMAM_API_RECIPE_SEARCH + "&app_id=" + API_EDAMAM_APP_ID + "&app_key=" + API_EDAMAM_APP_KEY + recipeURI
        
        let url = URL(string: urlStr)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            guard let retrievedData = data else { return }
            
            do {
                guard let jsonData = try JSONSerialization.jsonObject(with: retrievedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray else { return }
//                print(jsonData)
                guard let thisRecipe = jsonData.firstObject as? [String: Any] else { return }
                
                let recipeName = thisRecipe["label"] as! String
                let recipeImg = thisRecipe["image"] as! String
                var recipeURI = thisRecipe["uri"] as! String
                let recipeURL = thisRecipe["url"] as! String
                let recipeIngredients = thisRecipe["ingredientLines"] as! [String]
                let time = thisRecipe["totalTime"] as! Int
                let servings = thisRecipe["yield"] as! Int
                let calories = thisRecipe["calories"] as! Double
                let caloriesInt = Int(calories)
                recipeURI = self.configureRecipeURL(urlStr: recipeURI)
                let newRecipe = Recipe(name: recipeName, imgURL: recipeImg, uri: recipeURI, url: recipeURL, ingredients: recipeIngredients, time: time, servings: servings, calories: caloriesInt)

                
                // Get array of recipes with details for each recipe in the url (r=)
                completion(true, newRecipe)
            } catch {
                debugPrint(error.localizedDescription)
                completion(false, nil)
            }
        }
        
        task.resume()
    }
    
    func configureRecipeURL(urlStr: String) -> String {
        let slashURLStr = urlStr.replacingOccurrences(of: "/", with: "%2F")
        let colonURLStr = slashURLStr.replacingOccurrences(of: ":", with: "%3A")
        let hashTURLStr = colonURLStr.replacingOccurrences(of: "#", with: "%23")
        
        return hashTURLStr
    }
}
