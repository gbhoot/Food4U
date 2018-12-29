//
//  HomeViewController.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, SideBarIndexSelected, HomeVCFromSliderUp {

   // Outlets
   @IBOutlet weak var searchBar: UISearchBar!
   @IBOutlet weak var hamburgerBtn: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var mainView: UIView!
   @IBOutlet weak var mainTV: UITableView!
   
   // Variables
    var fuckFrame : CGRect = CGRect()
   let sideBarView = SideBarView()
   let slideUpSearchTV = SlideUpSearchTableView()
   var searchButton = UIButton()
   var prevTableViewFrame = CGRect()

    var recipeSearch = [Recipe]()
    var recipeFavs = [Recipe]()
    var ingredientSearch = [String]()
    var selectedRecipeIdx: Int?
    var selectedSection: Int?
    
    var searchButtonAppeared = false
   
   // Stale DATA
    var currentState = HOME
   var list = ["Recipe Favs", "Ingredients"]
   
   override func viewDidLoad() {
         super.viewDidLoad()
         self.view.addSubview(slideUpSearchTV)
         slideUpSearchTV.homeDelegate = self
         setupTableViews()
         setUpExtended()
         hamburgerBtn.setImage(UIImage(named: "HamburgerIcon"), for: .normal)
        self.view.addSubview(searchButton)
//         searchBar.showsBookmarkButton = true
//         searchBar.setImage(UIImage(named: "cameraIcon"), for: .bookmark, state: .normal)
//         loadRecipeData(forIngredients: ["chicken"])
//         pullRecipeFavs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        pullRecipeFavs()
//        self.removeSearchBarFromView()
        self.mainTV.reloadData()
    }
   
    func loadRecipeData(forIngredients: [String]) {
        EdamamService.instance.getRecipeList(withIngredients: forIngredients) { (success, recipeList) in
            if success {
                self.recipeSearch = recipeList
                DispatchQueue.main.async {
                    self.mainTV.reloadData()
                }
            }
        }
//        EdamamService.instance.getSingleRecipeDetails(withURI: "http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23recipe_9b5945e03f05acbf9d69625138385408") { (success, response) in
//            print(success, response)
//        }
    }
    
    func pullRecipeFavs() {
        self.recipeFavs = [Recipe]()
        let recipeFavorites = RecipeFavoriteService.instance.returnAllRecipeFavs()
        print(recipeFavorites.count)
        for fav in recipeFavorites {
            EdamamService.instance.getSingleRecipeDetails(withURI: fav.recipeURI!) { (success, recipe) in
                if success {
                    self.recipeFavs.append(recipe!)
                    print(self.recipeFavs.count)
                    DispatchQueue.main.async {
                        self.mainTV.reloadData()
                    }
                } else {
                    print("Failure")
                }
            }
        }
    }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      slideUpSearchTV.suggestionsFromSearch(searchStr: searchText)
   }
   
   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      self.activateSearch()
   }
   
   @objc func searchAction(sender: UIButton!) {
//      print("Button tapped")
      IngredientsDataService.instance.removeAllSpacesFromIngredients()
      ingredientSearch = IngredientsDataService.instance.returnAllIngredients()
      self.loadRecipeData(forIngredients: ingredientSearch)
      self.slideUpSearchTV.slideUp()
      backToHomeFromSearch()
   }
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      self.slideUpSearchTV.slideUp()
      resetTableViewFromSearch()
      self.view.endEditing(true)
   }
   
   func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
      self.view.endEditing(true)
      self.slideUpSearchTV.slideUp()
    
      performSegue(withIdentifier: "bringMoneyHome", sender: nil)
   }
    
    func closeSideBar(forIndexName: String) {
        self.backToHomeFromSideBar()
        if forIndexName == "shoppingList" {
            guard let shoppingListVC = storyboard?.instantiateViewController(withIdentifier: SB_ID_SHOPPING_LIST) else { return }
            present(shoppingListVC, animated: true, completion: nil)
        }
    }
    
    func reloadTableData() {
        self.view.endEditing(true)
        self.searchBar.text = ""
        slideUpSearchTV.suggestionsFromSearch(searchStr: "")
        self.slideUpSearchTV.slideUp()
        resetTableViewFromSearch()
        mainTV.reloadData()
    }
   
   @IBAction func sideBarBtnClicked(_ sender: Any) {
      //create a view programmatically
      if hamburgerBtn.imageView?.image == UIImage(named: "cancel"){
            self.searchBar.showsBookmarkButton = false
            self.backToHomeFromSearch()
      }else{
         if self.view.subviews.contains(sideBarView){
            self.backToHomeFromSideBar()
         }else{
            sideBarView.delegate = self
            self.searchBar.isUserInteractionEnabled = false
            self.showSideBar()
         }
      }
   }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {}
}
