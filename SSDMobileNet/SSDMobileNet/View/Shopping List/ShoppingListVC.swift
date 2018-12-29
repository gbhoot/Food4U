//
//  ShoppingListVC.swift
//  SSDMobileNet
//
//  Created by Gurpal Bhoot on 11/19/18.
//  Copyright © 2018 Mikael Von Holst. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var shoppingListTV: UITableView!
    
    // Variables
    var items: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        items = ShoppingListService.instance.returnShoppingList()
        shoppingListTV.reloadData()
    }
    
    // Functions
    func setupView() {
        setupTable()
    }
    
    func setupTable() {
        shoppingListTV.delegate = self
        shoppingListTV.dataSource = self
        shoppingListTV.reloadData()
    }
    
    // IB-Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items = ShoppingListService.instance.returnShoppingList()
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemList = items, let cell = tableView.dequeueReusableCell(withIdentifier: ID_REUSE_LIST_ITEM_CELL, for: indexPath) as? ListItemCell else { return UITableViewCell() }
        
        cell.configureCell(index: indexPath.row+1, itemName: itemList[indexPath.row])
        
        return cell
    }
}
