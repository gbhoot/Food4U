//
//  RecipeFavoriteService.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit
import CoreData

class RecipeFavoriteService {
    
    static let instance = RecipeFavoriteService()
    
    // Variables
    private var recipeFavs = [RecipeFavorite]()
    
    // Functions
    func addNewFavorite(recipeURI: String) {
        self.save(create: true, recipeURI: recipeURI) { (success) in
            if success {
                print("Created, saved and fetched")
            }
        }
    }
    
    func recipeIsFavorite(recipeURI: String) -> Bool {
        for recipe in recipeFavs {
            if recipe.recipeURI == recipeURI {
                return true
            }
        }
        
        return false
    }
    
    func removeFavorite(recipeURI: String) {
        for recipe in recipeFavs {
            if recipe.recipeURI == recipeURI {
                self.delete(recipe: recipe) { (success) in
                    if success {
                        print("Deleted, saved and fetched")
                    }
                }
            }
        }
    }
    
    func returnAllRecipeFavs() -> [RecipeFavorite] {
        fetchCoreData()
        
        return recipeFavs
    }
    
    // Core Data Functions
    func save(create: Bool, recipeURI: String?, completion: CompletionHandler) {
        guard let dataManager = appDelegate?.persistentContainer.viewContext else { return }
        
        if create {
            guard let uri = recipeURI else { return }
            let recipe = RecipeFavorite(context: dataManager)
            
            recipe.recipeURI = uri
        }
        
        do {
            try dataManager.save()
            fetchCoreData()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func delete(recipe: RecipeFavorite, completion: CompletionHandler) {
        guard let dataManager = appDelegate?.persistentContainer.viewContext else { return }
        
        dataManager.delete(recipe)
        
        do {
            try dataManager.save()
            fetchCoreData()
            completion(true)
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchCoreData() {
        self.fetch { (success) in
            if success {
                print("Successfully fetched data")
            }
        }
    }
    
    func fetch(completion: CompletionHandler) {
        guard let dataManager = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<RecipeFavorite>(entityName: "RecipeFavorite")
        
        do {
            recipeFavs = try dataManager.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Coud not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
