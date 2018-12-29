//
//  Home_Setup_Ext.swift
//  SSDMobileNet
//
//  Created by Kim Do on 11/15/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import Foundation
import UIKit
extension HomeViewController : HomeVCProtocol {
    func showRecipeDetail(index: Int, section: Int) {
        selectedRecipeIdx = index
        self.selectedSection = section
        performSegue(withIdentifier: SB_SEGUE_TO_RECIPE_INFO_VC, sender: nil)
   }
   
   func setUpExtended(){
      searchBar.delegate = self
      sideBarView.setUpFrame(viewFrame: self.view.frame, hamburgetBtnFrame: hamburgerBtn.frame)
      slideUpSearchTV.setUpFrame(frame: self.view.frame, searchBarFrame: self.searchBar.frame)
      NotificationCenter.default.addObserver(
         self,
         selector: #selector(keyboardWillShow),
         name: UIResponder.keyboardWillShowNotification,
         object: nil
      )
   }
   
   func setupTableViews() {
      self.prevTableViewFrame = self.tableView.frame
      mainTV.delegate         = self
      mainTV.dataSource       = self
      tableView.alwaysBounceVertical = false
      tableView.isScrollEnabled = false
      mainTV.reloadData()
        
   }
   
   @objc func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
         let keyboardHeight = keyboardFrame.cgRectValue.height
         let width :CGFloat = 100
         let height : CGFloat = 50
         let top     : CGFloat = (20 + self.searchBar.frame.height + self.slideUpSearchTV.frame.height + self.tableView.frame.height)
         let y = (self.view.frame.height - keyboardHeight - height + top) / 2
        fuckFrame = CGRect(x: self.view.frame.width / 2 -  width / 2, y: y, width: width, height: 50)
        self.loadSearchBarFrame()
      }
   }
    
    func loadSearchBarFrame() {        
        if !searchButtonAppeared{
            searchButton.backgroundColor = .green
            searchButton.setTitle("Search", for: .normal)
            searchButton.addTarget(self, action: #selector(self.searchAction), for: .touchUpInside)
            searchButton.layer.cornerRadius = 5
            searchButton.layer.borderWidth = 1
            searchButton.layer.borderColor = UIColor.black.cgColor

//            searchButtonAppeared = true
            searchButton.alpha = 1
            searchButton.frame = fuckFrame
            
//            self.searchButton.isHidden = false
        }
    }
    
    func removeSearchBarFromView() {
//        self.searchButtonAppeared = false
//        for eachView in view.subviews {
//            if eachView == searchButton {
//                eachView.removeFromSuperview()
//                eachView.isHidden = true
//            }
//        }
    }
 
   func setTableViewForSearch(){
      UIView.animate(withDuration: DURATION, animations: {
         self.tableView.frame = CGRect(x: 0, y: self.searchBar.frame.height + self.slideUpSearchTV.frame.height, width: self.view.frame.width , height: 200)
      })
      
   }
    
    func resetTableViewFromSearch() {
        UIView.animate(withDuration: DURATION) {
            self.tableView.frame = self.prevTableViewFrame
        }
    }
   
   func activateSearch(){
      self.hamburgerBtn.tintColor = UIColor.red
      UIView.animate(withDuration: DURATION, animations: {
         self.hamburgerBtn.setImage(UIImage(named: "cancel"), for: .normal)
         self.searchBar.showsBookmarkButton = true
         self.searchBar.setImage(UIImage(named: "cameraIcon"), for: .bookmark, state: .normal)
         self.slideUpSearchTV.slideDown()
         self.setTableViewForSearch()
         self.currentState = SEARCH
         self.mainTV.reloadData()
      })
   }
   
   func backToHomeFromSearch(){
      UIView.animate(withDuration: DURATION, animations: {

         self.slideUpSearchTV.slideUp()
         self.tableView.frame = self.prevTableViewFrame
         self.removeSearchBarFromView()
         self.hamburgerBtn.tintColor = UIColor.black
         self.hamburgerBtn.setImage(UIImage(named: "HamburgerIcon"), for: .normal)
         self.searchBar.text = ""
         self.currentState = HOME
         IngredientsDataService.instance.removeAllIngredients()
         self.ingredientSearch = [String]()
         self.removeSearchBarFromView()
         self.mainTV.reloadData()
         self.view.endEditing(true)
        self.searchButton.alpha = 0
      })
   }
   
   func backToHomeFromSideBar(){
      UIView.animate(withDuration: DURATION, animations: {
         self.sideBarView.slideOut()
         self.mainView.transform = CGAffineTransform(translationX: 0, y: 0)
      }) { (done) in
         self.searchBar.isUserInteractionEnabled = true
         self.sideBarView.removeFromSuperview()
      }
   }
   
   func showSideBar(){
      self.view.addSubview(sideBarView)
      
      UIView.animate(withDuration: DURATION){
         self.sideBarView.slideIn()
         self.mainView.transform = CGAffineTransform(translationX: self.sideBarView.width, y: 0)
      }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let desti = segue.destination as? RecipeInfoViewController, let section = self.selectedSection else { return }
        desti.currentRecipeIdx = selectedRecipeIdx
        if section == 0 {
            desti.recipes = recipeFavs
        } else {
            desti.recipes = recipeSearch
        }
    }
}
