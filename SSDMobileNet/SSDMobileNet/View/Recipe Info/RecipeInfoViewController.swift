//
//  RecipeInfoViewController.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class RecipeInfoViewController: UIViewController {
   
   // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var rNameTitleLbl: UILabel!
    @IBOutlet weak var rNameLbl: UILabel!
    @IBOutlet weak var rTimeTitleLbl: UILabel!
    @IBOutlet weak var rTimeLbl: UILabel!
    @IBOutlet weak var rServingsTitleLbl: UILabel!
    @IBOutlet weak var rServingsLbl: UILabel!
    @IBOutlet weak var ingredientsTV: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
   // Variables
    var recipes: [Recipe]?
    var currentRecipeIdx: Int?
    var nextDirection: String?
    var directions: [String]?

   override func viewDidLoad() {
        super.viewDidLoad()
      RecipeFavoriteService.instance.fetchCoreData()

        // Do any additional setup after loading the view.
      
      let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiperUp))
      swipeUp.direction = UISwipeGestureRecognizer.Direction.up
      self.view.addGestureRecognizer(swipeUp)
    
      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiperLeft))
      swipeRight.direction = UISwipeGestureRecognizer.Direction.right
      self.view.addGestureRecognizer(swipeRight)
    
      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwiperRight))
      swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
      self.view.addGestureRecognizer(swipeLeft)
    
      setupView()

    DataService.instance.sendRecipeURL(urls: [recipes![currentRecipeIdx!].recipeURL!]) { (success, directions) in
        self.directions = directions
    }
   }
   
   // Functions
    @objc func respondToSwiperUp() {
        guard let directionList = directions, let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return }
        let recipeDetailVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_RECIPE_DETAIL) as? RecipeDetailViewController
        let thisRecipe = allRecipes[thisIdx]
        recipeDetailVC?.recipe = thisRecipe
        recipeDetailVC?.directions = directionList
        if directionList.count > 0 {
            recipeDetailVC?.currentDirectionIndex = 0
        }
        
        presentFromBottom(recipeDetailVC!, self)
    }
    
    @objc func respondToSwiperLeft() {
        guard currentRecipeIdx! > 0 else { return }
        
        guard let recipeInfoVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_RECIPE_INFO) as? RecipeInfoViewController else { return }
        recipeInfoVC.recipes = recipes
        recipeInfoVC.currentRecipeIdx = self.currentRecipeIdx! - 1
        nextDirection = "left"
        self.presentFromRight(recipeInfoVC)
    }

    @objc func respondToSwiperRight() {
        guard currentRecipeIdx! < (recipes?.count)! - 1 else { return }
        
        guard let recipeInfoVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_RECIPE_INFO) as? RecipeInfoViewController else { return }
        recipeInfoVC.recipes = recipes
        recipeInfoVC.currentRecipeIdx = self.currentRecipeIdx! + 1
        nextDirection = "right"
        self.presentFromLeft(recipeInfoVC)
    }
    
    func setupView() {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return }
        let thisRecipe = allRecipes[thisIdx]
        self.backgroundView.addBackground(imageStr: thisRecipe.recipeImg!)
        
        setupLabels()
        setupTable()
        setupFavorite()
    }
    
    func setupLabels() {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return }
        let thisRecipe = allRecipes[thisIdx]
        rNameLbl.text = thisRecipe.recipeName!
        rTimeLbl.text = "\(thisRecipe.recipeTime!) mins"
        if thisRecipe.recipeTime! == 0 {
            rTimeLbl.text = "Unknown"
        }
        rServingsLbl.text = "\(thisRecipe.recipeServings!)"
        if thisRecipe.recipeServings == 0 {
            rServingsLbl.text = "Unknown"
        }
//        setupLabelWidths()
    }
    
    func setupLabelWidths() {
        let titleWidth = (rNameTitleLbl.bounds.width / 2) - 3
        let titleHeight = rNameTitleLbl.bounds.height
        rNameTitleLbl.frame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
        rTimeTitleLbl.frame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
        rServingsTitleLbl.frame = CGRect(x: 0, y: 0, width: titleWidth, height: titleHeight)
    }
    
    func setupTable() {
        ingredientsTV.delegate = self
        ingredientsTV.dataSource = self
        ingredientsTV.reloadData()
    }
    
    func setupFavorite() {
        if checkRecipeFavStatus() {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite"), for: .normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "not-favorite"), for: .normal)
        }
    }
    
    func checkRecipeFavStatus() -> Bool {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return false }
        let thisRecipe = allRecipes[thisIdx]
        return RecipeFavoriteService.instance.recipeIsFavorite(recipeURI: thisRecipe.recipeURI!)
    }
    
    func checkIngredientInShoppingList(itemName: String) -> Bool {
        return ShoppingListService.instance.itemIsInShoppingList(itemName: itemName)
    }

   // IB-Actions
    @IBAction func goBackBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SB_UNWIND_SEGUE_TO_HOME_VC, sender: self)
    }
    
    @IBAction func unwindBackToRecipeInfo(segue: UIStoryboardSegue) {}
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let allRecipes = recipes, let thisIdx = currentRecipeIdx else { return }
        let thisRecipe = allRecipes[thisIdx]
        if checkRecipeFavStatus() {
            RecipeFavoriteService.instance.removeFavorite(recipeURI: thisRecipe.recipeURI!)
        } else {
            RecipeFavoriteService.instance.addNewFavorite(recipeURI: thisRecipe.recipeURI!)
        }
        
        setupFavorite()
    }
}
