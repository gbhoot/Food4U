//
//  ShoppingListService.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class ShoppingListService {
    
    static let instance = ShoppingListService()
    
    private var listItems = [String]()
    
    func addShoppingItem(itemName: String) {
        listItems.append(itemName)
        print("Added this to the list: ", itemName)
    }
    
    func itemIsInShoppingList(itemName: String) -> Bool {
        for item in listItems {
            if item == itemName {
                return true
            }
        }
        
        return false
    }
    
    func removeShoppingItem(byIndex index: Int) {
        listItems.remove(at: index)
    }
    
    func removeShoppingItem(byItemName name: String) {
        var count = 0
        for item in listItems {
            if item == name {
                listItems.remove(at: count)
            } else {
                count += 1
            }
        }
        print("Removed this to the list: ", name)
    }
    
    func returnShoppingList() -> [String] {
        return listItems
    }
}
